import 'package:flutter/material.dart';

/// Light / dark theme preference. Starts in light mode; visitors can switch
/// with the header toggle.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  /// Switches to the opposite of the [current] effective brightness.
  void toggleTheme(Brightness current) {
    setDarkMode(current == Brightness.light);
  }

  /// Set theme explicitly
  void setDarkMode(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
