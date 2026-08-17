import 'package:flutter/material.dart';
import 'package:my_todo_app/model/task.dart';
import 'package:my_todo_app/service/todo_service.dart';

class TaskList extends ChangeNotifier {
  final List<Task> _tasks = [];
  String _currentFilter = "Alle";

  List<Task> get tasks => _tasks;

  void safeTaskList() async {
    await TodoService.saveToDoList(_tasks);
    notifyListeners();
  }

  void loadTaskList() async {
    _tasks.clear();
    _tasks.addAll(await TodoService.loadToDoList());
    notifyListeners();
  }

  void clearTasks() async {
    _tasks.clear();
    await TodoService.clearData();
    notifyListeners();
  }

  Task getTaskByTitle(String title) {
    sortByAscending();
    for (var task in _tasks) {
      if (task.title == title) {
        return task;
      }
    }
    throw Exception("Keinen passenden task gefunden");
  }

  void sortByAscending() {
    _tasks.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void sortByDescending() {
    _tasks.sort((a, b) => b.title.compareTo(a.title));
    notifyListeners();
  }

  void sortByPriority() {
    int PriorityToInt(Priority value) => value == Priority.low
        ? 3
        : value == Priority.medium
        ? 2
        : 1;
    _tasks.sort(
      (a, b) => PriorityToInt(a.priority).compareTo(PriorityToInt(b.priority)),
    );
    notifyListeners();
  }

  void sortByDueDate() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  void changeCompletionState(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void changePriority(Task task, Priority newPriority) {
    task.priority = newPriority;
    notifyListeners();
  }

  void changeTitle(Task task, String newTitle) {
    task.title = newTitle;
    notifyListeners();
  }

  void changeDescription(Task task, String newDescription) {
    task.description = newDescription;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    print("Neue Aufgabe hinzugefügt");
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  String get currentFilter => _currentFilter;

  void setFilter(String newFilter) {
    _currentFilter = newFilter;
    notifyListeners();
  }

  List<Task> getTasks(String filter) {
    switch (filter) {
      case "Alle":
        return _tasks;
      case "Erledigt":
        return _tasks.where((task) => task.isCompleted == true).toList();
      case "Offen":
        return _tasks.where((task) => task.isCompleted == false).toList();
      default:
        return _tasks;
    }
  }
}
