import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_todo_app/model/task_list.dart';
import 'package:my_todo_app/theme/theme_notifier.dart';
import 'package:my_todo_app/view/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('de_DE', '');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskList()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    return MaterialApp(
      title: "My Todo List",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.theme,
      home: const HomeScreen(),
    );
  }
}
