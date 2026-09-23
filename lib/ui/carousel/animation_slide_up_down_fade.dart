import 'package:flutter/material.dart';

class WidgetSlideUpDownFadeAnimation extends StatelessWidget {
  final Duration duration;
  final Offset offset;
  final bool direction;
  final Widget child;

  const WidgetSlideUpDownFadeAnimation(
      {super.key,
      required this.duration,
      required this.offset,
      required this.direction,
      required this.child});

  @override
  Widget build(BuildContext context) {
    // Use more efficient TweenAnimationBuilder for better performance
    return TweenAnimationBuilder<double>(
      duration: duration,
      // `begin` only applies to the first build: start hidden so layers that
      // are not yet due don't flash in and fade out when a slide appears.
      // Later changes animate from the current value to the new `end`.
      tween: Tween<double>(begin: 0.0, end: direction ? 1.0 : 0.0),
      curve: direction ? Curves.easeInOut : Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1.0 - value),
              offset.dy * (1.0 - value),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
