import 'package:flutter/material.dart';
import 'package:flutter_website/components/typography.dart' show symbolFallback;

/// Professional typography system with clear hierarchy for 2026 design
class ModernTypography {
  // Display styles - largest, most prominent
  static const displayLarge = TextStyle(
    fontSize: 56.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -1.0,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  static const displayMedium = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  static const displaySmall = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  // Heading styles - major sections
  static const headlineLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  static const headlineMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: 0,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  static const headlineSmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
    fontFamily: 'Brand Sans',
    fontFamilyFallback: symbolFallback,
  );

  // Title styles - subsections
  static const titleLarge = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const titleMedium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const titleSmall = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  // Body styles - main content
  static const bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.55,
    letterSpacing: 0.3,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  // Label styles - buttons, tabs, etc
  static const labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.55,
    letterSpacing: 0.4,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 0.3,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  // Special styles
  static const captionText = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const overlineText = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 1.0,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  // Button text
  static const buttonLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const buttonMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.2,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );

  static const buttonSmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.4,
    fontFamily: 'Roboto',
    fontFamilyFallback: symbolFallback,
  );
}
