import 'package:flutter/material.dart';
import 'package:flutter_website/components/app_palette.dart';
import '../components/modern_colors.dart';
import '../components/modern_typography.dart';
import '../components/modern_shadows.dart';

/// Enhanced theme generator using modern design system
class ModernThemeBuilder {
  // Cache themes to avoid rebuilding
  static ThemeData? _cachedLightTheme;
  static ThemeData? _cachedDarkTheme;

  static ThemeData buildLightTheme() {
    return _cachedLightTheme ??= _createLightTheme();
  }

  static ThemeData buildDarkTheme() {
    return _cachedDarkTheme ??= _createDarkTheme();
  }

  static ThemeData _createLightTheme() {
    return ThemeData(
      extensions: const [AppPalette.light],
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: ModernColors.primary,
        onPrimary: ModernColors.textWhite,
        primaryContainer: ModernColors.primaryLight,
        onPrimaryContainer: ModernColors.primary,
        secondary: ModernColors.accent,
        onSecondary: ModernColors.textWhite,
        error: ModernColors.error,
        onError: ModernColors.textWhite,
        surface: ModernColors.backgroundCard,
        onSurface: ModernColors.textPrimary,
      ),

      // Text theme with modern typography
      textTheme: TextTheme(
        displayLarge: ModernTypography.displayLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
        displayMedium: ModernTypography.displayMedium.copyWith(
          color: ModernColors.textPrimary,
        ),
        displaySmall: ModernTypography.displaySmall.copyWith(
          color: ModernColors.textPrimary,
        ),
        headlineLarge: ModernTypography.headlineLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
        headlineMedium: ModernTypography.headlineMedium.copyWith(
          color: ModernColors.textPrimary,
        ),
        headlineSmall: ModernTypography.headlineSmall.copyWith(
          color: ModernColors.textPrimary,
        ),
        titleLarge: ModernTypography.titleLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
        titleMedium: ModernTypography.titleMedium.copyWith(
          color: ModernColors.textPrimary,
        ),
        titleSmall: ModernTypography.titleSmall.copyWith(
          color: ModernColors.textPrimary,
        ),
        bodyLarge: ModernTypography.bodyLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
        bodyMedium: ModernTypography.bodyMedium.copyWith(
          color: ModernColors.textSecondary,
        ),
        bodySmall: ModernTypography.bodySmall.copyWith(
          color: ModernColors.textTertiary,
        ),
        labelLarge: ModernTypography.labelLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
        labelMedium: ModernTypography.labelMedium.copyWith(
          color: ModernColors.textPrimary,
        ),
        labelSmall: ModernTypography.labelSmall.copyWith(
          color: ModernColors.textSecondary,
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: ModernColors.backgroundCard,
        foregroundColor: ModernColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ModernColors.textPrimary),
        titleTextStyle: ModernTypography.headlineSmall.copyWith(
          color: ModernColors.textPrimary,
        ),
        toolbarHeight: 64,
        toolbarTextStyle: ModernTypography.bodyLarge.copyWith(
          color: ModernColors.textPrimary,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ModernColors.primary,
          foregroundColor: ModernColors.textWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModernRadius.md),
          ),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return 4;
            if (states.contains(WidgetState.pressed)) return 1;
            return 2;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return ModernColors.textTertiary;
            }
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primaryLight;
            }
            return ModernColors.primary;
          }),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ModernColors.primary,
          side: const BorderSide(
            color: ModernColors.border,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModernRadius.md),
          ),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.hovered)) {
              return const BorderSide(
                color: ModernColors.primary,
                width: 2,
              );
            }
            return const BorderSide(
              color: ModernColors.border,
              width: 1.5,
            );
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primary.withOpacity(0.05);
            }
            return Colors.transparent;
          }),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ModernColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primary.withOpacity(0.08);
            }
            return Colors.transparent;
          }),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: ModernColors.backgroundCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.lg),
          side: const BorderSide(
            color: ModernColors.border,
            width: 1,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ModernColors.background,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(color: ModernColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.error,
            width: 2,
          ),
        ),
        labelStyle: ModernTypography.labelLarge.copyWith(
          color: ModernColors.textSecondary,
        ),
        hintStyle: ModernTypography.bodyMedium.copyWith(
          color: ModernColors.textTertiary,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: ModernColors.border,
        thickness: 1,
        space: 16,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: ModernColors.backgroundHover,
        selectedColor: ModernColors.primary,
        disabledColor: ModernColors.border,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.sm),
        ),
        labelStyle: ModernTypography.labelMedium.copyWith(
          color: ModernColors.textPrimary,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: ModernColors.textPrimary,
        size: 24,
      ),

      // Scaffold background
      scaffoldBackgroundColor: ModernColors.background,

      // Other theme properties
      canvasColor: ModernColors.background,
      disabledColor: ModernColors.textTertiary,
      highlightColor: ModernColors.primary.withOpacity(0.1),
      hoverColor: ModernColors.primary.withOpacity(0.08),
    );
  }

  static ThemeData _createDarkTheme() {
    return ThemeData(
      extensions: const [AppPalette.dark],
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: ModernColors.primaryLight,
        onPrimary: ModernColors.textPrimary,
        primaryContainer: ModernColors.primary,
        onPrimaryContainer: ModernColors.textWhite,
        secondary: ModernColors.accent,
        onSecondary: ModernColors.textPrimary,
        error: ModernColors.error,
        onError: ModernColors.textWhite,
        surface: ModernColors.backgroundCardDark,
        onSurface: ModernColors.textLight,
      ),

      // Text theme with modern typography
      textTheme: TextTheme(
        displayLarge: ModernTypography.displayLarge.copyWith(
          color: ModernColors.textWhite,
        ),
        displayMedium: ModernTypography.displayMedium.copyWith(
          color: ModernColors.textWhite,
        ),
        displaySmall: ModernTypography.displaySmall.copyWith(
          color: ModernColors.textLight,
        ),
        headlineLarge: ModernTypography.headlineLarge.copyWith(
          color: ModernColors.textLight,
        ),
        headlineMedium: ModernTypography.headlineMedium.copyWith(
          color: ModernColors.textLight,
        ),
        headlineSmall: ModernTypography.headlineSmall.copyWith(
          color: ModernColors.textLight,
        ),
        titleLarge: ModernTypography.titleLarge.copyWith(
          color: ModernColors.textLight,
        ),
        titleMedium: ModernTypography.titleMedium.copyWith(
          color: ModernColors.textLight,
        ),
        titleSmall: ModernTypography.titleSmall.copyWith(
          color: ModernColors.textTertiary,
        ),
        bodyLarge: ModernTypography.bodyLarge.copyWith(
          color: ModernColors.textLight,
        ),
        bodyMedium: ModernTypography.bodyMedium.copyWith(
          color: ModernColors.textTertiary,
        ),
        bodySmall: ModernTypography.bodySmall.copyWith(
          color: ModernColors.textTertiary,
        ),
        labelLarge: ModernTypography.labelLarge.copyWith(
          color: ModernColors.textLight,
        ),
        labelMedium: ModernTypography.labelMedium.copyWith(
          color: ModernColors.textLight,
        ),
        labelSmall: ModernTypography.labelSmall.copyWith(
          color: ModernColors.textTertiary,
        ),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: ModernColors.backgroundCardDark,
        foregroundColor: ModernColors.textLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: ModernColors.textLight),
        titleTextStyle: ModernTypography.headlineSmall.copyWith(
          color: ModernColors.textLight,
        ),
        toolbarHeight: 64,
        toolbarTextStyle: ModernTypography.bodyLarge.copyWith(
          color: ModernColors.textLight,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ModernColors.primaryLight,
          foregroundColor: ModernColors.textPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModernRadius.md),
          ),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) return 4;
            if (states.contains(WidgetState.pressed)) return 1;
            return 2;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return ModernColors.textTertiary;
            }
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primary;
            }
            return ModernColors.primaryLight;
          }),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ModernColors.primaryLight,
          side: const BorderSide(
            color: ModernColors.borderDark,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModernRadius.md),
          ),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.hovered)) {
              return const BorderSide(
                color: ModernColors.primaryLight,
                width: 2,
              );
            }
            return const BorderSide(
              color: ModernColors.borderDark,
              width: 1.5,
            );
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primaryLight.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ModernColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: ModernTypography.buttonLarge,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return ModernColors.primaryLight.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: ModernColors.backgroundCardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.lg),
          side: const BorderSide(
            color: ModernColors.borderDark,
            width: 1,
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ModernColors.backgroundDark,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(color: ModernColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.borderDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ModernRadius.md),
          borderSide: const BorderSide(
            color: ModernColors.error,
            width: 2,
          ),
        ),
        labelStyle: ModernTypography.labelLarge.copyWith(
          color: ModernColors.textTertiary,
        ),
        hintStyle: ModernTypography.bodyMedium.copyWith(
          color: ModernColors.textTertiary,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: ModernColors.borderDark,
        thickness: 1,
        space: 16,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: ModernColors.backgroundCardDark,
        selectedColor: ModernColors.primaryLight,
        disabledColor: ModernColors.borderDark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModernRadius.sm),
        ),
        labelStyle: ModernTypography.labelMedium.copyWith(
          color: ModernColors.textLight,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: ModernColors.textLight,
        size: 24,
      ),

      // Scaffold background
      scaffoldBackgroundColor: ModernColors.backgroundDark,

      // Other theme properties
      canvasColor: ModernColors.backgroundDark,
      disabledColor: ModernColors.textTertiary,
      highlightColor: ModernColors.primaryLight.withOpacity(0.1),
      hoverColor: ModernColors.primaryLight.withOpacity(0.08),
    );
  }
}
