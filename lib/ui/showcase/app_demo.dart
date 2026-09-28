import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/showcase/demo_kit.dart';
import 'package:flutter_website/ui/showcase/demo_screens.dart';
import 'package:flutter_website/ui/showcase/phone_frame.dart';
import 'package:provider/provider.dart';

/// A phone playing a scripted walkthrough of [app], built from real Flutter
/// widgets (not a video). A finger taps through the flow, notifications drop
/// in, and visitors can tap or swipe the phone to step through it. Only
/// plays while on screen; waits for taps when reduced motion is requested.
class AppDemo extends StatefulWidget {
  const AppDemo({
    super.key,
    required this.app,
    required this.platform,
    this.height = 560,
  });

  final DemoApp app;
  final TargetPlatform platform;

  /// Height of the phone; the caption below adds ~40 px.
  final double height;

  @override
  State<AppDemo> createState() => _AppDemoState();
}

class _AppDemoState extends State<AppDemo> with SingleTickerProviderStateMixin {
  static const _stepDuration = Duration(milliseconds: 3400);

  late final AnimationController _clock =
      AnimationController(vsync: this, duration: _stepDuration)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) _go(_step + 1);
        });
  final _targets = <String, BuildContext>{};
  final _screenKey = GlobalKey();
  int _step = 0;
  bool _back = false;
  bool _visible = false;

  DemoAppSpec get _spec => demoApps[widget.app]!;

  bool get _autoplay => _visible && !MediaQuery.disableAnimationsOf(context);

  @override
  void didUpdateWidget(AppDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.app != widget.app) {
      _step = 0;
      _back = false;
      _restartClock();
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _restartClock() {
    _clock.value = 0;
    if (_autoplay) _clock.forward();
  }

  /// Shows step [step] (wrapping around); going to an earlier step plays
  /// the "back" transition.
  void _go(int step) {
    final count = _spec.steps.length;
    final next = step % count;
    setState(() {
      _back = next < _step || _spec.steps[next].back;
      _step = next;
    });
    _restartClock();
  }

  void _onVisible(bool visible) {
    _visible = visible;
    if (_autoplay) {
      _clock.forward();
    } else {
      _clock.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec;
    final step = spec.steps[_step];
    final theme =
        demoTheme(spec.seed, widget.platform, Theme.of(context).brightness);
    final ios = widget.platform == TargetPlatform.iOS;
    final tr = context.watch<LocaleProvider>().tr;
    final pageKey = ValueKey('${widget.app.name}/${step.screen}');

    final pages = AnimatedSwitcher(
      duration: Duration(milliseconds: ios ? 420 : 300),
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        // When going back, the page leaving slides out on top.
        children: _back
            ? [if (current != null) current, ...previous]
            : [...previous, if (current != null) current],
      ),
      transitionBuilder: (child, animation) {
        final incoming = child.key == pageKey;
        if (ios) {
          final begin = incoming
              ? Offset(_back ? -0.3 : 1, 0)
              : Offset(_back ? 1 : -0.3, 0);
          return SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        }
        // Material "fade through": the new page fades in while growing.
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: incoming ? 0.92 : 1.0, end: 1.0)
                .animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: pageKey,
        child: ColoredBox(
          color: theme.scaffoldBackgroundColor,
          child: spec.build(_step),
        ),
      ),
    );

    final screen = Stack(
      key: _screenKey,
      children: [
        // Cross-fade the whole app when the platform switches.
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: KeyedSubtree(
              key: ValueKey(widget.platform),
              child: Theme(data: theme, child: pages),
            ),
          ),
        ),
        if (step.notice != null)
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: _NoticeSlide(
              clock: _clock,
              child: DemoNotification(
                app: spec.name,
                icon: spec.icon,
                title: spec.name,
                body: tr(step.notice!),
                now: tr('demo.now'),
              ),
            ),
          ),
        if (step.tap != null && !MediaQuery.disableAnimationsOf(context))
          Positioned.fill(
            child: IgnorePointer(
              child: _Finger(
                clock: _clock,
                locate: () {
                  final box = _screenKey.currentContext?.findRenderObject()
                      as RenderBox?;
                  if (box == null || !box.hasSize) return null;
                  return DemoTargets.centerOf(_targets, step.tap!, box);
                },
              ),
            ),
          ),
      ],
    );

    return OnScreen(
      once: false,
      onChanged: _onVisible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: '${spec.name} — ${tr(step.caption)}',
            button: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _go(_step + 1),
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (velocity < -100) _go(_step + 1);
                  if (velocity > 100) _go(_step - 1);
                },
                child: Theme(
                  data: theme,
                  child: DemoTargets(
                    targets: _targets,
                    child: PhoneFrame(
                      platform: widget.platform,
                      height: widget.height,
                      screen: screen,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _Caption(
            steps: spec.steps.length,
            current: _step,
            color: spec.seed,
            text: tr(step.caption),
            onSelect: _go,
          ),
        ],
      ),
    );
  }
}

/// Slides a notification down early in the step and away at its end.
class _NoticeSlide extends StatelessWidget {
  const _NoticeSlide({required this.clock, required this.child});

  final Animation<double> clock;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: clock,
      builder: (context, child) {
        final t = clock.value;
        final enter =
            Curves.easeOutBack.transform(((t - 0.12) / 0.14).clamp(0.0, 1.0));
        final exit = ((t - 0.9) / 0.1).clamp(0.0, 1.0);
        return Opacity(
          opacity: (enter.clamp(0.0, 1.0) * (1 - exit)),
          child: Transform.translate(
            offset: Offset(0, -110 * (1 - enter)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// The scripted finger: appears over the target, presses (with a ripple)
/// just before the step ends.
class _Finger extends StatelessWidget {
  const _Finger({required this.clock, required this.locate});

  final Animation<double> clock;
  final Offset? Function() locate;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: clock,
      builder: (context, _) {
        final t = clock.value;
        if (t < 0.55) return const SizedBox.shrink();
        final center = locate();
        if (center == null) return const SizedBox.shrink();
        final appear =
            Curves.easeOut.transform(((t - 0.55) / 0.12).clamp(0.0, 1.0));
        final press = ((t - 0.8) / 0.18).clamp(0.0, 1.0);
        final pressing = t > 0.78 && t < 0.9;
        return Stack(
          children: [
            // Ripple ring
            if (press > 0)
              Positioned(
                left: center.dx - 18 - 26 * press,
                top: center.dy - 18 - 26 * press,
                child: Container(
                  width: 36 + 52 * press,
                  height: 36 + 52 * press,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8 * (1 - press)),
                      width: 3,
                    ),
                  ),
                ),
              ),
            // Fingertip
            Positioned(
              left: center.dx - 20,
              top: center.dy - 20,
              child: Opacity(
                opacity: appear * (1 - press * 0.6),
                child: Transform.scale(
                  scale: (1.5 - 0.5 * appear) * (pressing ? 0.82 : 1),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.55),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.25), width: 1.5),
                      boxShadow: const [
                        BoxShadow(color: Color(0x40000000), blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Step dots (tappable) and the current step's caption.
class _Caption extends StatelessWidget {
  const _Caption({
    required this.steps,
    required this.current,
    required this.color,
    required this.text,
    required this.onSelect,
  });

  final int steps;
  final int current;
  final Color color;
  final String text;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < steps; i++)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onSelect(i),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: i == current ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == current ? color : palette.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            '${current + 1}/$steps · $text',
            key: ValueKey(text),
            textAlign: TextAlign.center,
            style: bodyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary),
          ),
        ),
      ],
    );
  }
}
