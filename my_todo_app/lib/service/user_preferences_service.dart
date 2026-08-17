import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const String _isDarkModeKey = "isDarkMode";

  static Future<void> setDarkmode(bool isDarkmode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkmode);
  }

  static Future<bool> isDarkModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  static Future<void> resetAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
