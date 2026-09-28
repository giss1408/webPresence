import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_website/config/environment.dart';
import 'package:flutter_website/i18n/translations.dart';

/// WhatsApp integration service for messaging
class WhatsAppService {
  /// WhatsApp business number, digits only (the format wa.me links take).
  static const String businessPhone = '4917634620220';

  /// The same number as shown to visitors.
  static const String displayPhone = '+49 176 346 20 220';

  // Default message templates — now using Translations.translate
  static String get defaultMessage =>
      Translations.translate('wa.general', 'fr');

  /// Returns a translated template message for the given [templateKey] and [locale].
  static String getTemplateMessage(String templateKey, String locale) {
    return Translations.translate('wa.$templateKey', locale);
  }

  /// Launch WhatsApp with default message
  static Future<void> openWhatsApp({String? message}) async {
    final text = message ?? defaultMessage;
    await _launchWhatsApp(businessPhone, text);
  }

  /// Launch WhatsApp with predefined template
  static Future<void> openWhatsAppWithTemplate(String templateKey,
      {String locale = 'fr'}) async {
    final message = getTemplateMessage(templateKey, locale);
    await _launchWhatsApp(businessPhone, message);
  }

  /// Launch WhatsApp with custom message
  static Future<void> openWhatsAppWithCustomMessage(String message) async {
    await _launchWhatsApp(businessPhone, message);
  }

  /// Internal method to launch WhatsApp
  static Future<void> _launchWhatsApp(String phone, String message) async {
    try {
      // URL encode the message
      final encodedMessage = Uri.encodeComponent(message);

      // Create WhatsApp link
      // For web, use the WhatsApp Web URL
      final whatsappUrl = 'https://wa.me/$phone?text=$encodedMessage';

      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (AppConfig.isDevelopment) {
          debugPrint('Could not launch WhatsApp: $whatsappUrl');
        }
      }
    } catch (e) {
      if (AppConfig.isDevelopment) {
        debugPrint('Error launching WhatsApp: $e');
      }
    }
  }

  /// Get formatted phone number for display
  static String getFormattedPhone() {
    return displayPhone;
  }

  /// Get WhatsApp link for direct sharing
  static String getWhatsAppLink({String? message}) {
    final text = message ?? defaultMessage;
    final encodedMessage = Uri.encodeComponent(text);
    return 'https://wa.me/$businessPhone?text=$encodedMessage';
  }
}
