import 'package:flutter/material.dart';
import 'package:my_todo_app/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Einstellungen"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [ThemeSwitchButton()]),
        ),
      ),
    );
  }
}

class ThemeSwitchButton extends StatefulWidget {
  const ThemeSwitchButton({super.key});

  @override
  State<ThemeSwitchButton> createState() => _ThemeSwitchButtonState();
}

class _ThemeSwitchButtonState extends State<ThemeSwitchButton> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final isDarkMode = themeNotifier.theme == ThemeMode.dark;

    return SwitchListTile(
      title: Text("Dark Mode"),
      value: isDarkMode,
      onChanged: (bool newValue) {
        context.read<ThemeNotifier>().setTheme(
          newValue ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
