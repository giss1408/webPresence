import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_website/i18n/translations.dart';

/// Utility class for locale and localization operations
class LocaleUtils {
  /// All supported locale codes
  static const List<String> supportedLocales = ['fr', 'en', 'de'];

  /// Default locale (French)
  static const String defaultLocale = 'fr';

  /// Get the display name of a locale
  static String getDisplayName(String locale) {
    return Translations.localeName(locale);
  }

  /// Get the native name of a locale (how it's called in that language)
  static String getNativeName(String locale) {
    switch (locale) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return locale.toUpperCase();
    }
  }

  /// Get the language code icon/emoji for a locale
  static String getLocaleEmoji(String locale) {
    switch (locale) {
      // French is shown with the Côte d'Ivoire flag (the site's main market).
      case 'fr':
        return '🇨🇮';
      case 'en':
        return '🇬🇧';
      case 'de':
        return '🇩🇪';
      default:
        return '🌐';
    }
  }

  /// Map an app locale to an ISO country code for flag rendering
  static String getCountryCode(String locale) {
    switch (locale) {
      case 'fr':
        return 'CI';
      case 'en':
        return 'GB';
      case 'de':
        return 'DE';
      default:
        return 'UN';
    }
  }

  /// Convert string locale code to Flutter Locale object
  static Locale toLocale(String code) {
    if (!supportedLocales.contains(code)) {
      return const Locale(defaultLocale);
    }
    return Locale(code);
  }

  /// Check if a locale is supported
  static bool isSupported(String locale) => supportedLocales.contains(locale);

  /// Get the next locale in the cycle (FR → EN → DE → FR)
  static String nextLocale(String current) {
    final index = supportedLocales.indexOf(current);
    if (index == -1) return defaultLocale;
    return supportedLocales[(index + 1) % supportedLocales.length];
  }

  /// Get all available locales with their display names
  static Map<String, String> getAvailableLocales() {
    return {
      for (final locale in supportedLocales) locale: getDisplayName(locale)
    };
  }

  /// Build a list of supported Flutter Locales
  static List<Locale> buildSupportedFlutterLocales() {
    return supportedLocales.map((code) => Locale(code)).toList();
  }

  /// Get all localization delegates for MaterialApp
  static List<LocalizationsDelegate<dynamic>> getLocalizationDelegates() {
    return const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }

  /// Groups the digits of [amount] the way [locale] writes numbers:
  /// "450 000" (fr), "450,000" (en), "450.000" (de).
  static String groupDigits(num amount, String locale) {
    final digits = amount.round().abs().toString();
    final separator = switch (locale) {
      'en' => ',',
      'de' => '.',
      _ => '\u202F', // narrow no-break space, French convention
    };
    final grouped = digits.replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => separator);
    return amount < 0 ? '-$grouped' : grouped;
  }

  /// Formats a price in [currency] ("FCFA", "USD") for [locale].
  static String formatPrice(num amount, String currency, String locale) {
    final value = groupDigits(amount, locale);
    if (currency == 'USD') return locale == 'en' ? '\$$value' : '$value \$';
    return locale == 'en' ? '$currency $value' : '$value $currency';
  }
}
