import 'package:flutter/material.dart';

/// Building blocks for the demo apps shown in [PhoneFrame]. Each one follows
/// `Theme.of(context).platform`, so the same screen code looks like an iOS
/// or an Android app — which is what the platform toggle demonstrates.

bool isIos(BuildContext context) =>
    Theme.of(context).platform == TargetPlatform.iOS;

/// Theme of a demo app: its brand [seed], the site's light / dark mode and
/// the platform's typeface.
ThemeData demoTheme(
    Color seed, TargetPlatform platform, Brightness brightness) {
  final ios = platform == TargetPlatform.iOS;
  return ThemeData(
    useMaterial3: true,
    platform: platform,
    fontFamily: ios ? 'Google Sans' : 'Roboto',
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      // Keeps the primary colour true to the brand instead of a muted tone.
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    ),
  );
}

/// "90 000 FCFA" with the locale's thousands separator.
String fcfa(int amount, String locale) {
  final separator = switch (locale) { 'en' => ',', 'de' => '.', _ => ' ' };
  final digits = '$amount';
  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(separator);
    grouped.write(digits[i]);
  }
  return '$grouped FCFA';
}

// ─── Tap targets ──────────────────────────────────────────────────────────────

/// Where the demo's scripted finger taps: maps a target id to the widget
/// currently showing it. Ids are looked up after layout, so the finger
/// follows translations, platform switches and resizes.
class DemoTargets extends InheritedWidget {
  const DemoTargets({super.key, required this.targets, required super.child});

  /// Owned by the demo player so it survives rebuilds.
  final Map<String, BuildContext> targets;

  static DemoTargets? _of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DemoTargets>();

  /// Centre of target [id] of [targets] in [ancestor]'s coordinates, if it
  /// is on screen.
  static Offset? centerOf(
      Map<String, BuildContext> targets, String id, RenderBox ancestor) {
    final target = targets[id];
    if (target == null || !target.mounted) return null;
    final box = target.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(box.size.center(Offset.zero), ancestor: ancestor);
  }

  @override
  bool updateShouldNotify(DemoTargets oldWidget) =>
      targets != oldWidget.targets;
}

/// Marks [child] as the tap target [id] of the demo script.
class DemoTarget extends StatefulWidget {
  const DemoTarget({super.key, required this.id, required this.child});

  final String id;
  final Widget child;

  @override
  State<DemoTarget> createState() => _DemoTargetState();
}

class _DemoTargetState extends State<DemoTarget> {
  @override
  Widget build(BuildContext context) {
    // The most recently built copy wins (e.g. the incoming screen of a
    // platform cross-fade).
    DemoTargets._of(context)?.targets[widget.id] = context;
    return widget.child;
  }
}

// ─── Adaptive widgets ─────────────────────────────────────────────────────────

/// Navigation bar: centred title and chevron on iOS, left-aligned title and
/// arrow on Android. [large] shows an iOS large title / Android headline.
class DemoAppBar extends StatelessWidget {
  const DemoAppBar({
    super.key,
    required this.title,
    this.back = false,
    this.backTarget,
    this.trailing,
    this.large = false,
  });

  final String title;
  final bool back;

  /// Tap target id of the back button.
  final String? backTarget;
  final Widget? trailing;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    Widget? backButton;
    if (back) {
      backButton = Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(ios ? Icons.arrow_back_ios_new : Icons.arrow_back,
            size: ios ? 20 : 24,
            color: ios ? scheme.primary : scheme.onSurface),
      );
      if (backTarget != null) {
        backButton = DemoTarget(id: backTarget!, child: backButton);
      }
    }
    if (large) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 6, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: ios ? 30 : 26,
                    fontWeight: ios ? FontWeight.w700 : FontWeight.w400,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      );
    }
    final titleText = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: ios ? 17 : 21,
        fontWeight: ios ? FontWeight.w600 : FontWeight.w400,
        color: scheme.onSurface,
      ),
    );
    return SizedBox(
      height: ios ? 46 : 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ios
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: titleText,
                  ),
                  if (backButton != null)
                    Align(alignment: Alignment.centerLeft, child: backButton),
                  if (trailing != null)
                    Align(alignment: Alignment.centerRight, child: trailing),
                ],
              )
            : Row(
                children: [
                  if (backButton != null)
                    backButton
                  else
                    const SizedBox(width: 10),
                  const SizedBox(width: 8),
                  Expanded(child: titleText),
                  if (trailing != null) trailing!,
                ],
              ),
      ),
    );
  }
}

/// Primary button: rounded rectangle on iOS, pill on Android.
class DemoButton extends StatelessWidget {
  const DemoButton({
    super.key,
    required this.label,
    required this.target,
    this.icon,
  });

  final String label;
  final String target;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    return DemoTarget(
      id: target,
      child: Container(
        height: ios ? 50 : 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(ios ? 13 : 23),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: scheme.onPrimary),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: ios ? 16 : 14,
                  fontWeight: ios ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: ios ? 0 : 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation: tab bar with tinted icons on iOS, Material 3 navigation
/// bar with a pill behind the selected icon on Android.
class DemoNavBar extends StatelessWidget {
  const DemoNavBar({super.key, required this.items, this.selected = 0});

  final List<(IconData, String)> items;
  final int selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    return Container(
      height: ios ? 54 : 68,
      decoration: BoxDecoration(
        color: ios
            ? scheme.surface
            : Color.alphaBlend(
                scheme.primary.withOpacity(0.08), scheme.surface),
        border: ios
            ? Border(top: BorderSide(color: scheme.outlineVariant, width: 0.5))
            : null,
      ),
      child: Row(
        children: [
          for (final (i, (icon, label)) in items.indexed)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ios ? null : 56,
                    height: ios ? null : 30,
                    decoration: BoxDecoration(
                      color: !ios && i == selected
                          ? scheme.secondaryContainer
                          : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      size: ios ? 24 : 22,
                      color: i == selected
                          ? (ios ? scheme.primary : scheme.onSecondaryContainer)
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: ios ? 2 : 4),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: ios ? 10 : 11,
                      fontWeight:
                          i == selected ? FontWeight.w600 : FontWeight.w400,
                      color: i == selected && ios
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A push notification: frosted rounded card on iOS, Material card with the
/// app name header on Android.
class DemoNotification extends StatelessWidget {
  const DemoNotification({
    super.key,
    required this.app,
    required this.icon,
    required this.title,
    required this.body,
    required this.now,
  });

  final String app;
  final IconData icon;
  final String title;
  final String body;
  final String now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    final appIcon = Container(
      width: ios ? 36 : 20,
      height: ios ? 36 : 20,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(ios ? 9 : 10),
      ),
      child: Icon(icon, size: ios ? 20 : 12, color: scheme.onPrimary),
    );
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface)),
        const SizedBox(height: 2),
        Text(body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12, height: 1.3, color: scheme.onSurfaceVariant)),
      ],
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ios
            ? scheme.surfaceContainerHighest.withOpacity(0.96)
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(ios ? 20 : 18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 6)),
        ],
      ),
      child: ios
          ? Row(
              children: [
                appIcon,
                const SizedBox(width: 10),
                Expanded(child: textColumn),
                const SizedBox(width: 6),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(now,
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant)),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    appIcon,
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text('$app • $now',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11, color: scheme.onSurfaceVariant)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                textColumn,
              ],
            ),
    );
  }
}

/// In-app confirmation: dark rounded toast on iOS, Material snackbar on
/// Android. Slides in when first shown.
class DemoToast extends StatelessWidget {
  const DemoToast({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child:
            Transform.translate(offset: Offset(0, 24 * (1 - t)), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ios ? const Color(0xEE1C1C1E) : scheme.inverseSurface,
          borderRadius: BorderRadius.circular(ios ? 14 : 6),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18, color: ios ? Colors.white : scheme.inversePrimary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: ios ? Colors.white : scheme.onInverseSurface)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grouped content card: inset grouped list style on iOS, filled card on
/// Android.
class DemoCard extends StatelessWidget {
  const DemoCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ios = isIos(context);
    return Container(
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            ios ? scheme.surfaceContainerLow : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(ios ? 12 : 16),
      ),
      child: child,
    );
  }
}
