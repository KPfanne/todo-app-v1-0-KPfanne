import 'package:flutter/material.dart';
import 'package:my_todo_app/model/task.dart';
import 'package:my_todo_app/model/task_list.dart';
import 'package:my_todo_app/view/task_details_screen.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id),
      confirmDismiss: (direction) async {
        if (!widget.task.isCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Aufgabe ist noch nicht erfüllt!")),
          );
          return false;
        }
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Löschen bestätigen"),
              content: const Text(
                "Möchtest du diese Aufgabe wirklich löschen?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Abbrechen"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Löschen",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TaskList>().removeTask(widget.task);
        context.read<TaskList>().safeTaskList();
      },
      child: Stack(
        children: [
          Card(
            elevation: 8,
            color: widget.task.isCompleted == true
                ? Colors.blueGrey
                : widget.task.priority == Priority.low
                ? Colors.green
                : widget.task.priority == Priority.medium
                ? Colors.amber
                : Colors.redAccent,
            child: ListTile(
              title: Text(
                widget.task.title,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              subtitle: Text(
                widget.task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              ),
              trailing: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  side: BorderSide(color: Colors.black, width: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: widget.task.isCompleted,
                  onChanged: (_) {
                    context.read<TaskList>().changeCompletionState(widget.task);
                    context.read<TaskList>().safeTaskList();
                  },
                ),
              ),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailsScreen(task: widget.task),
                  ),
                ),
              },
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                margin: EdgeInsetsDirectional.only(top: 5),
                child: Text(
                  widget.task.priority.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 5,
            child: Text(
              widget.task.getCreatedAt(),
              style: TextStyle(color: Colors.black),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 5,
            child: Text(
              widget.task.getDueDate(),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
