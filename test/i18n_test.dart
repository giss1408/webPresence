import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_website/i18n/translations.dart';

void main() {
  test('every translation has a non-empty FR, EN and DE value', () {
    final incomplete = [
      for (final MapEntry(:key, :value) in Translations.entries.entries)
        for (final locale in Translations.supportedLocales)
          if ((value[locale] ?? '').trim().isEmpty) '$key [$locale]',
    ];
    expect(incomplete, isEmpty);
  });

  test('every key used in the code exists', () {
    final keyPattern =
        RegExp(r"""(?:tr|translate)\(\s*'([a-z_0-9]+\.[a-z_0-9.]+)'""");
    // Keys stored in data and translated at display time.
    final dataKeyPattern = RegExp(
        r"""'((?:portfolio|carousel|demo|sync|showcase)\.[a-z_0-9.]+)'""");
    final missing = <String>{};
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path.endsWith('translations.dart')) continue;
      final source = file.readAsStringSync();
      for (final match in [
        ...keyPattern.allMatches(source),
        ...dataKeyPattern.allMatches(source),
      ]) {
        final key = match.group(1)!;
        if (!Translations.entries.containsKey(key)) {
          missing.add('$key (${file.path})');
        }
      }
    }
    expect(missing, isEmpty);
  });
}
