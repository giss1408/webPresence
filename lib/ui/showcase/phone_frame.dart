import 'package:flutter/material.dart';

/// Size of the phone's screen in logical pixels. Screens are laid out at this
/// size and the whole phone is scaled to the space it is given.
const Size phoneScreenSize = Size(300, 640);
const double _bezel = 11;
const Size phoneSize =
    Size(300 + 2 * _bezel, 640 + 2 * _bezel); // screen + bezel

/// A phone drawn in code: Dynamic Island and home bar on iOS, camera hole
/// and gesture bar on Android. [screen] fills the display below the status
/// bar and above the home / gesture bar.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.platform,
    required this.screen,
    this.height = 560,
    this.systemBars = true,
  });

  final TargetPlatform platform;
  final Widget screen;

  /// Rendered height; the width follows the phone's aspect ratio.
  final double height;

  /// Draws the status bar and home / gesture bar. Off for screen
  /// recordings, which already contain them.
  final bool systemBars;

  bool get _ios => platform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onSurface;
    final outerRadius = _ios ? 50.0 : 38.0;
    return SizedBox(
      height: height,
      width: height * phoneSize.width / phoneSize.height,
      child: FittedBox(
        child: SizedBox.fromSize(
          size: phoneSize,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            padding: const EdgeInsets.all(_bezel),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0F12),
              borderRadius: BorderRadius.circular(outerRadius),
              border: Border.all(color: const Color(0xFF3A3D45), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 40,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(outerRadius - _bezel),
              child: ColoredBox(
                color: theme.scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    if (!systemBars)
                      Positioned.fill(child: screen)
                    else
                      Column(
                        children: [
                          _StatusBar(ios: _ios, color: foreground),
                          Expanded(child: screen),
                          SizedBox(
                            height: _ios ? 22 : 18,
                            child: Center(
                              child: Container(
                                width: _ios ? 110 : 90,
                                height: _ios ? 5 : 4,
                                decoration: BoxDecoration(
                                  color: foreground.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    // Dynamic Island / camera hole, drawn over the screen.
                    Positioned(
                      top: _ios ? 10 : 9,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          width: _ios ? 92 : 13,
                          height: _ios ? 27 : 13,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.ios, required this.color});

  final bool ios;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final time = Text(
      ios ? '9:41' : '09:41',
      style: TextStyle(
        color: color,
        fontSize: ios ? 15 : 13,
        fontWeight: ios ? FontWeight.w600 : FontWeight.w500,
      ),
    );
    final icons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.signal_cellular_alt, size: 15, color: color),
        const SizedBox(width: 4),
        Icon(Icons.wifi, size: 15, color: color),
        const SizedBox(width: 4),
        Icon(ios ? Icons.battery_full : Icons.battery_5_bar,
            size: 16, color: color),
      ],
    );
    return SizedBox(
      height: ios ? 48 : 34,
      child: Padding(
        padding: EdgeInsets.fromLTRB(ios ? 30 : 18, ios ? 4 : 0, 22, 0),
        child: Row(
          children: [
            // On iOS the clock sits left of the island, centred in its half.
            if (ios) Expanded(child: Center(child: time)) else time,
            ios ? const SizedBox(width: 110) : const Spacer(),
            if (ios) Expanded(child: Center(child: icons)) else icons,
          ],
        ),
      ),
    );
  }
}
