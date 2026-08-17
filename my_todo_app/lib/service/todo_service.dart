import 'dart:convert';

import 'package:my_todo_app/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  static const String _tasksKey = "tasks";

  static Future<void> saveToDoList(List<Task> taskList) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> tasks = taskList
        .map((task) => jsonEncode(task.toMap()))
        .toList();

    await prefs.setStringList(_tasksKey, tasks);
  }

  static Future<List<Task>> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? jsonList = prefs.getStringList(_tasksKey) ?? [];

    return jsonList
        .map((jsonString) => Task.fromMap(jsonDecode(jsonString)))
        .toList();
  }

  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
