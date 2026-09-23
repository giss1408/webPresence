import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/i18n/locale_utils.dart';

/// Simple flag-only language switcher - tap to cycle through languages
class LanguageSwitcherMenu extends StatelessWidget {
  final EdgeInsets padding;
  final double borderRadius;

  const LanguageSwitcherMenu({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final current = localeProvider.locale;

        return Tooltip(
          message: localeProvider
              .tr('lang.tooltip')
              .replaceAll('{lang}', LocaleUtils.getNativeName(current)),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                localeProvider.cycleLocale();
              },
              child: Container(
                padding: padding,
                child: CountryFlag.fromCountryCode(
                  LocaleUtils.getCountryCode(current),
                  shape: const RoundedRectangle(4),
                  width: 32,
                  height: 24,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
