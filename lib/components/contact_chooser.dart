import 'package:flutter/material.dart';
import 'package:flutter_website/components/app_palette.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/config/environment.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/services/whatsapp_service.dart';
import 'package:flutter_website/utils/utils.dart';
import 'package:provider/provider.dart';

/// Asks how the visitor wants to send a request — WhatsApp or e-mail — and
/// opens it with the message for [messageKey] already written.
Future<void> showContactChooser(BuildContext context,
    {required String messageKey}) {
  final localeProvider = context.read<LocaleProvider>();
  final message = localeProvider.tr(messageKey);
  final subject = localeProvider.tr('contact.mail_subject');
  final palette = context.palette;

  return showModalBottomSheet(
    context: context,
    backgroundColor: palette.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      void choose(Future<void> Function() open) {
        Navigator.pop(sheetContext);
        open();
      }

      return SafeArea(
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(localeProvider.tr('contact.title'),
                      style: headlineSecondaryTextStyle.copyWith(
                          fontSize: 20, color: palette.textPrimary)),
                  const SizedBox(height: 6),
                  Text(localeProvider.tr('contact.subtitle'),
                      style: bodyTextStyle.copyWith(
                          fontSize: 14, color: palette.textSecondary)),
                  const SizedBox(height: 20),
                  _ChannelTile(
                    icon: Icons.chat_bubble_outline,
                    color: const Color(0xFF25D366),
                    title: localeProvider.tr('contact.whatsapp'),
                    subtitle: localeProvider.tr('contact.whatsapp_hint'),
                    onTap: () => choose(
                        () => WhatsAppService.openWhatsApp(message: message)),
                  ),
                  const SizedBox(height: 12),
                  _ChannelTile(
                    icon: Icons.mail_outline,
                    color: palette.accent,
                    title: localeProvider.tr('contact.email'),
                    subtitle: AppConfig.companyEmail,
                    onTap: () => choose(() async {
                      // Encoded by hand: Uri's queryParameters would turn
                      // spaces into '+', which mail apps show as is.
                      await openUrl(
                          'mailto:${AppConfig.companyEmail}'
                          '?subject=${Uri.encodeComponent(subject)}'
                          '&body=${Uri.encodeComponent(message)}',
                          sameTab: true);
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surfaceMuted,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: headlineSecondaryTextStyle.copyWith(
                            fontSize: 16, color: palette.textPrimary)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: bodyTextStyle.copyWith(
                            fontSize: 13, color: palette.textSecondary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: palette.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
