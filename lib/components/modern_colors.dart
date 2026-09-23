import 'package:flutter/material.dart';

/// Modern, professional color palette for 2026
class ModernColors {
  // Primary colors with gradients
  static const Color primary = Color(0xFF1389FD);
  static const Color primaryLight = Color(0xFF3FA9FF);
  static const Color primaryDark = Color(0xFF0075E6);
  static const Color primaryGradientStart = Color(0xFF1389FD);
  static const Color primaryGradientEnd = Color(0xFF0056B3);

  // Accent colors
  static const Color accent = Color(0xFF00D9FF);
  static const Color accentWarm = Color(0xFFFF6B35);
  static const Color accentGreen = Color(0xFF00B369);
  static const Color accentPurple = Color(0xFF7C3AED);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFCBD5E1);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Background colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  static const Color backgroundCardDark = Color(0xFF1E293B);
  static const Color backgroundHover = Color(0xFFF1F5F9);

  // Border & divider colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);
  static const Color divider = Color(0xFFE2E8F0);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF0EA5E9);

  // Overlay colors
  static const Color overlay = Color(0x1F000000);
  static const Color overlayDark = Color(0x3F000000);

  // Gradient definitions
  static LinearGradient primaryGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static LinearGradient accentGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentWarm],
  );

  static LinearGradient heroGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1389FD),
      Color(0xFF0EA5E9),
    ],
  );
}
