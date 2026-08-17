import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String _id;
  String title;
  String description;
  bool isCompleted = false;
  final DateTime _createdAt;
  DateTime dueDate;
  Priority priority;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  }) : _id = const Uuid().v4(),
       _createdAt = DateTime.now();

  Task._({
    required this._id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this._createdAt,
    required this.dueDate,
    required this.priority,
  });

  String get id => _id;

  String getCreatedAt() {
    String formatedString = DateFormat(
      'dd.MM.yyyy',
      'de_DE',
    ).format(_createdAt);
    return formatedString;
  }

  String getDueDate() {
    String formatedString = DateFormat('dd.MM.yyyy', 'de_DE').format(dueDate);
    return formatedString;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "createdAt": _createdAt.toIso8601String(),
      "dueDate": dueDate.toIso8601String(),
      "priority": priority.label,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    print(map["createdAt"]);
    print(map["createdAt"].runtimeType);
    return Task._(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      isCompleted: map["isCompleted"],
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"])
          : DateTime.now(),
      dueDate: map["dueDate"] != null
          ? DateTime.parse(map["dueDate"])
          : DateTime.now(),
      priority: Priority.values.firstWhere(
        (priority) => priority.label == map["priority"],
      ),
    );
  }
}

enum Priority {
  low("Low"),
  medium("Medium"),
  high("High");

  final String label;
  const Priority(this.label);
}
