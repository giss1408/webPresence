import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/showcase/app_demo.dart';
import 'package:flutter_website/ui/showcase/demo_screens.dart';
import 'package:flutter_website/ui/showcase/phone_frame.dart';
import 'package:provider/provider.dart';

/// "Live demo" section: pick one of our apps and a platform, and watch it
/// run in a phone next to the pitch. [selection], when given, lets other
/// widgets (the portfolio cards) choose the app.
class AppShowcase extends StatefulWidget {
  const AppShowcase({super.key, this.selection, this.showPortfolioLink = true});

  final ValueNotifier<DemoApp>? selection;
  final bool showPortfolioLink;

  @override
  State<AppShowcase> createState() => _AppShowcaseState();
}

class _AppShowcaseState extends State<AppShowcase> {
  late final ValueNotifier<DemoApp> _app =
      widget.selection ?? ValueNotifier(DemoApp.akwaba);

  /// Start on the visitor's own platform when it is a phone.
  TargetPlatform _platform = defaultTargetPlatform == TargetPlatform.android
      ? TargetPlatform.android
      : TargetPlatform.iOS;

  @override
  void dispose() {
    if (widget.selection == null) _app.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.watch<LocaleProvider>().tr;
    final palette = context.palette;
    final isDesktop = context.isDesktop;
    final isNarrow = context.screenWidth < 520;

    return ValueListenableBuilder<DemoApp>(
      valueListenable: _app,
      builder: (context, app, _) {
        final spec = demoApps[app]!;

        final intro = Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: palette.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _LiveDot(),
                  const SizedBox(width: 8),
                  Text(tr('showcase.badge'),
                      style: bodyTextStyle.copyWith(
                          fontSize: 11,
                          color: palette.accent,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(
              tr('showcase.title'),
              style: headlineTextStyle.copyWith(
                  fontSize: isNarrow ? 28 : 34, height: 1.2),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              tr('showcase.body'),
              style: bodyTextStyle.copyWith(
                  fontSize: 16, color: palette.textSecondary, height: 1.7),
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            ),
          ],
        );

        // App and platform pickers, key points, link.
        final controls = Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
              children: [
                for (final option in DemoApp.values)
                  _AppChip(
                    spec: demoApps[option]!,
                    label: [
                      demoApps[option]!.name,
                      if (demoApps[option]!.tag case final tag?) tr(tag),
                    ].join(' · '),
                    selected: option == app,
                    onTap: () => _app.value = option,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            SegmentedButton<TargetPlatform>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: TargetPlatform.iOS,
                  label: Text('iOS'),
                  icon: Icon(Icons.apple),
                ),
                ButtonSegment(
                  value: TargetPlatform.android,
                  label: Text('Android'),
                  icon: Icon(Icons.android),
                ),
              ],
              selected: {_platform},
              onSelectionChanged: (selection) =>
                  setState(() => _platform = selection.first),
            ),
            const SizedBox(height: 26),
            for (final (icon, key) in const [
              (Icons.devices_outlined, 'showcase.point1'),
              (Icons.speed_outlined, 'showcase.point2'),
              (Icons.dark_mode_outlined, 'showcase.point3'),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisSize: isDesktop ? MainAxisSize.max : MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 20, color: palette.accent),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(tr(key),
                          style: bodyTextStyle.copyWith(
                              fontSize: 14.5,
                              height: 1.5,
                              color: palette.textPrimary)),
                    ),
                  ],
                ),
              ),
            if (widget.showPortfolioLink) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/portfolio'),
                icon: const Icon(Icons.arrow_forward, size: 18),
                iconAlignment: IconAlignment.end,
                label: Text(tr('showcase.portfolio')),
              ),
            ],
          ],
        );

        final phone = LayoutBuilder(
          builder: (context, constraints) {
            // Fit the phone's width into narrow screens.
            final maxByWidth =
                constraints.maxWidth * phoneSize.height / phoneSize.width;
            final height = math.min(isDesktop ? 600.0 : 540.0, maxByWidth);
            final glow = math.min(constraints.maxWidth, height * 0.8);
            return SizedBox(
              width: constraints.maxWidth,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Soft glow in the app's brand colour behind the phone.
                  Positioned(
                    top: (height - glow) / 2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      width: glow,
                      height: glow,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                          spec.seed.withOpacity(context.isDark ? 0.35 : 0.25),
                          spec.seed.withOpacity(0),
                        ]),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDemo(app: app, platform: _platform, height: height),
                      const SizedBox(height: 6),
                      Text(tr('showcase.hint'),
                          textAlign: TextAlign.center,
                          style: bodyTextStyle.copyWith(
                              fontSize: 12, color: palette.textMuted)),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          margin: blockMargin,
          padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 64 : (isNarrow ? 16 : 32),
              vertical: isDesktop ? 64 : 44),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [intro, const SizedBox(height: 26), controls],
                      ),
                    ),
                    const SizedBox(width: 56),
                    SizedBox(width: 420, child: phone),
                  ],
                )
              : Column(
                  children: [
                    // On phones the demo comes right after the intro, above
                    // the pickers that drive it.
                    intro,
                    const SizedBox(height: 28),
                    phone,
                    const SizedBox(height: 24),
                    controls,
                  ],
                ),
        );
      },
    );
  }
}

class _AppChip extends StatelessWidget {
  const _AppChip({
    required this.spec,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final DemoAppSpec spec;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? spec.seed : palette.surface,
            border: Border.all(color: selected ? spec.seed : palette.border),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(spec.icon,
                  size: 17, color: selected ? Colors.white : spec.seed),
              const SizedBox(width: 7),
              Text(label,
                  style: bodyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : palette.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pulsing "live" dot of the badge.
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFE53935);
    return SizedBox(
      width: 10,
      height: 10,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 6 + 6 * _pulse.value,
              height: 6 + 6 * _pulse.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: red.withOpacity(0.5 * (1 - _pulse.value)),
              ),
            ),
            Container(
              width: 6,
              height: 6,
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: red),
            ),
          ],
        ),
      ),
    );
  }
}
