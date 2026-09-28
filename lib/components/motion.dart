import 'package:flutter/material.dart';

/// Reports whether [child] is inside the visible part of the screen while the
/// enclosing page scrolls. With [once], stops listening after the first
/// time it becomes visible (entrance animations); otherwise reports every
/// change (to pause looping animations that are scrolled away).
class OnScreen extends StatefulWidget {
  const OnScreen({
    super.key,
    required this.onChanged,
    required this.child,
    this.once = true,
  });

  final ValueChanged<bool> onChanged;
  final Widget child;
  final bool once;

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  ScrollPosition? _position;
  bool _visible = false;
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position;
      if (!_done) _position?.addListener(_check);
    }
    // Also re-checks after a resize (MediaQuery is a dependency of _check).
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (!mounted || _done) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    final visible =
        top < screenHeight * 0.9 && top + box.size.height > screenHeight * 0.1;
    if (visible == _visible) return;
    _visible = visible;
    widget.onChanged(visible);
    if (visible && widget.once) {
      _done = true;
      _position?.removeListener(_check);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Fades and slides [child] up the first time it scrolls into view.
/// Paint-only: layout (and in-page anchors) is the same before and after.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;

  /// Stagger for items revealed together (cards in a row).
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 700);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay + _duration,
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMilliseconds / (widget.delay + _duration).inMilliseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnScreen(
      onChanged: (visible) {
        if (visible) _controller.forward();
      },
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) => Opacity(
          opacity: _progress.value,
          child: Transform.translate(
            offset: Offset(0, 36 * (1 - _progress.value)),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

/// Shows [value] ("50+", "98 %", "<4 wks") and counts its number up from 0
/// the first time it scrolls into view. Values without a number are shown
/// as they are.
class CountUp extends StatefulWidget {
  const CountUp(this.value, {super.key, this.style, this.textAlign});

  final String value;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  late final Animation<double> _progress =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'\d+').firstMatch(widget.value);
    return OnScreen(
      onChanged: (visible) {
        if (visible) _controller.forward();
      },
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          var text = widget.value;
          if (match != null) {
            final target = int.parse(match.group(0)!);
            text = widget.value.replaceRange(match.start, match.end,
                '${(target * _progress.value).round()}');
          }
          return Text(text, style: widget.style, textAlign: widget.textAlign);
        },
      ),
    );
  }
}
