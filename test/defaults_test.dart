import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_website/i18n/locale_utils.dart';
import 'package:flutter_website/providers/theme_provider.dart';

void main() {
  test('site starts in light mode', () {
    expect(ThemeProvider().themeMode, ThemeMode.light);
  });

  test('French is shown with the Côte d\'Ivoire flag', () {
    expect(LocaleUtils.getCountryCode('fr'), 'CI');
  });
}
