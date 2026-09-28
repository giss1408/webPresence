import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_website/main.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/providers/theme_provider.dart';
import 'package:provider/provider.dart';

/// Loads the real fonts so text measures like in the browser (the default
/// test font is much wider and would report false overflows).
Future<void> _loadFonts() async {
  const families = {
    'Google Sans': [
      'assets/fonts/product_sans_regular.ttf',
      'assets/fonts/product_sans_bold.ttf',
    ],
    'Roboto': [
      'assets/fonts/roboto_regular.ttf',
      'assets/fonts/roboto_bold.ttf',
      'assets/fonts/roboto_italic.ttf',
    ],
  };
  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }
}

Widget _app({required bool dark, String locale = 'fr'}) {
  final theme = ThemeProvider()..setDarkMode(dark);
  final localeProvider = LocaleProvider()..setLocale(locale);
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: theme),
      ChangeNotifierProvider.value(value: localeProvider),
    ],
    child: MyApp(localeProvider: localeProvider),
  );
}

void main() {
  setUpAll(_loadFonts);

  const widths = [
    320.0,
    360.0,
    390.0,
    480.0,
    600.0,
    768.0,
    851.0,
    900.0,
    1024.0,
    1100.0,
    1280.0,
    1440.0
  ];

  for (final dark in [false, true]) {
    for (final locale in ['fr', 'en', 'de']) {
      for (final width in widths) {
        testWidgets(
            'home renders without overflow at ${width.toInt()}px '
            '(${dark ? 'dark' : 'light'}, $locale)', (tester) async {
          tester.view.physicalSize = Size(width, 900);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(_app(dark: dark, locale: locale));
          await tester.pump(const Duration(seconds: 1));

          // Scroll through the whole page so every section is painted.
          final scrollable = find.byType(Scrollable).first;
          for (var i = 0; i < 40; i++) {
            await tester.drag(scrollable, const Offset(0, -600));
            await tester.pump(const Duration(milliseconds: 50));
          }
          expect(tester.takeException(), isNull);

          await tester.pumpWidget(const SizedBox());
        });
      }
    }
  }

  const routes = [
    '/portfolio',
  ];
  for (final dark in [false, true]) {
    for (final locale in ['fr', 'en', 'de']) {
      for (final route in routes) {
        for (final width in [360.0, 768.0, 1024.0, 1440.0]) {
          testWidgets(
              '$route renders without overflow at ${width.toInt()}px '
              '(${dark ? 'dark' : 'light'}, $locale)', (tester) async {
            tester.view.physicalSize = Size(width, 900);
            tester.view.devicePixelRatio = 1;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(_app(dark: dark, locale: locale));
            await tester.pump(const Duration(milliseconds: 500));
            tester
                .state<NavigatorState>(find.byType(Navigator).first)
                .pushNamed(route);
            await tester.pump(const Duration(seconds: 1));

            final scrollable = find.byType(Scrollable).last;
            for (var i = 0; i < 15; i++) {
              await tester.drag(scrollable, const Offset(0, -600),
                  warnIfMissed: false);
              await tester.pump(const Duration(milliseconds: 50));
            }
            expect(tester.takeException(), isNull);

            await tester.pumpWidget(const SizedBox());
          });
        }
      }
    }
  }
}
