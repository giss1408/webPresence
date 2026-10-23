import 'package:flutter/material.dart';

import 'theme_storage/theme_storage.dart';

/// Light / dark theme preference, shared with the blog and the other static
/// pages: the choice saved there (or here) applies on both, and without a
/// saved choice the site follows the device setting.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider()
      : _themeMode = switch (readSavedTheme()) {
          'dark' => ThemeMode.dark,
          'light' => ThemeMode.light,
          _ => systemPrefersDark() ? ThemeMode.dark : ThemeMode.light,
        };

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  /// Switches to the opposite of the [current] effective brightness.
  void toggleTheme(Brightness current) {
    setDarkMode(current == Brightness.light);
  }

  /// Sets the theme explicitly and remembers it for the static pages too.
  void setDarkMode(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    saveTheme(isDark ? 'dark' : 'light');
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
