import 'package:flutter/material.dart';

import 'components.dart';

Widget buildMaterialIconCircle(
    BuildContext context, String imagePath, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: context.palette.accentSoft,
    ),
    child: Align(
      alignment: Alignment.center,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        width: size * 0.5,
        height: size * 0.5,
      ),
    ),
  );
}
