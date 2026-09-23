import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';

/// Centers a home page block and caps its width per breakpoint.
class BlockWrapper extends StatelessWidget {
  final Widget widget;

  const BlockWrapper(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final maxWidth = width < 850 ? 600.0 : (width <= 1080 ? 700.0 : 1280.0);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: widget,
      ),
    );
  }
}
