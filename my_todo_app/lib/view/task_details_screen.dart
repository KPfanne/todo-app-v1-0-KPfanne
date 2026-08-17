import 'package:flutter/material.dart';
import 'package:my_todo_app/model/task.dart';
import 'package:my_todo_app/model/task_list.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Priority _selectedValue = Priority.high;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16,
              children: [
                // Title
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Titel',
                    hintText: 'Mindestens 1 Zeichen',
                    suffixIcon: InkWell(
                      onTap: () {
                        context.read<TaskList>().changeTitle(
                          widget.task,
                          titleController.text,
                        );
                        context.read<TaskList>().safeTaskList();
                      },
                      child: Icon(Icons.save),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte einen Titel eingeben";
                    }
                    return null;
                  },
                ),
                // Description
                TextFormField(
                  controller: descriptionController,
                  maxLines: 10,
                  maxLength: 400,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'Mindestens 1 Zeichen',
                    suffix: InkWell(
                      onTap: () {
                        context.read<TaskList>().changeDescription(
                          widget.task,
                          descriptionController.text,
                        );
                        context.read<TaskList>().safeTaskList();
                      },
                      child: Icon(Icons.save),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Bitte eine Beschreibung eingeben";
                    }
                    return null;
                  },
                ),
                // Priority DropDownMenu
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Priorität: "),
                    DropdownButton<Priority>(
                      value: _selectedValue,
                      items: Priority.values.map((option) {
                        return DropdownMenuItem<Priority>(
                          value: option,
                          child: Text(option.label),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedValue = newValue;
                          });
                        }
                      },
                    ),
                    InkWell(
                      onTap: () {
                        context.read<TaskList>().changePriority(
                          widget.task,
                          _selectedValue,
                        );
                        context.read<TaskList>().safeTaskList();
                      },
                      child: Icon(Icons.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _selectedValue = widget.task.priority;

    titleController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
    super.initState();
  }
}
