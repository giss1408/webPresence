import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/i18n/locale_utils.dart';

/// Compact language switcher that cycles FR → EN → DE
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final current = localeProvider.locale;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => localeProvider.cycleLocale(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromCountryCode(
                    LocaleUtils.getCountryCode(current),
                    shape: const RoundedRectangle(3),
                    width: 22,
                    height: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    current.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16, color: const Color(0xFF6E7274)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
