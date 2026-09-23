import 'package:flutter/material.dart';

/// Theme-aware colors for the website sections. Read with `context.palette`
/// so every block follows light / dark mode instead of hardcoding white.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  /// Card and section background.
  final Color surface;

  /// Slightly tinted surface for nested cards.
  final Color surfaceMuted;

  /// Header / navigation bar background.
  final Color header;

  /// Headings and body copy.
  final Color textPrimary;

  /// Secondary copy: subtitles, descriptions.
  final Color textSecondary;

  /// Tertiary copy: captions, footnotes.
  final Color textMuted;

  /// Hairline borders and dividers.
  final Color border;

  /// Soft brand tint behind badges, pillars and icon circles.
  final Color accentSoft;

  /// Brand color used for text/icons on [accentSoft] or [surface].
  final Color accent;

  /// Large faded numerals (process step numbers).
  final Color numeral;

  const AppPalette({
    required this.surface,
    required this.surfaceMuted,
    required this.header,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.accentSoft,
    required this.accent,
    required this.numeral,
  });

  static const light = AppPalette(
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF7F9FC),
    header: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF4B5563),
    textMuted: Color(0xFF6B7280),
    border: Color(0xFFE5E7EB),
    accentSoft: Color(0xFFEFF8FF),
    accent: Color(0xFF1389FD),
    numeral: Color(0xFFD6EBFF),
  );

  static const dark = AppPalette(
    surface: Color(0xFF1E293B),
    surfaceMuted: Color(0xFF172136),
    header: Color(0xFF111A2E),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFFCBD5E1),
    textMuted: Color(0xFF94A3B8),
    border: Color(0xFF334155),
    accentSoft: Color(0xFF16325A),
    accent: Color(0xFF5CB0FF),
    numeral: Color(0xFF28446B),
  );

  @override
  AppPalette copyWith({
    Color? surface,
    Color? surfaceMuted,
    Color? header,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? accentSoft,
    Color? accent,
    Color? numeral,
  }) =>
      AppPalette(
        surface: surface ?? this.surface,
        surfaceMuted: surfaceMuted ?? this.surfaceMuted,
        header: header ?? this.header,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textMuted: textMuted ?? this.textMuted,
        border: border ?? this.border,
        accentSoft: accentSoft ?? this.accentSoft,
        accent: accent ?? this.accent,
        numeral: numeral ?? this.numeral,
      );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      header: Color.lerp(header, other.header, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      numeral: Color.lerp(numeral, other.numeral, t)!,
    );
  }
}

/// Layout breakpoints, read synchronously from [MediaQuery] so the very first
/// frame (and every frame during a resize) already uses the right layout.
extension SiteLayout on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Phones and small tablets in portrait (< 850 px).
  bool get isMobile => screenWidth < 850;

  /// Wide screens (> 1080 px) that get multi-column section layouts.
  bool get isDesktop => screenWidth > 1080;
}
