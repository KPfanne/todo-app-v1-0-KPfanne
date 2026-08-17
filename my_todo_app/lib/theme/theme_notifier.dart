import 'package:flutter/material.dart';
import 'package:my_todo_app/service/user_preferences_service.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _theme = ThemeMode.system;

  ThemeMode get theme => _theme;

  ThemeNotifier() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final isDark = await UserPreferencesService.isDarkModeEnabled();
    _theme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode newTheme) async {
    _theme = newTheme;
    notifyListeners();
    await UserPreferencesService.setDarkmode(newTheme == ThemeMode.dark);
  }
}
