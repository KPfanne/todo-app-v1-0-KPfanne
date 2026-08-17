import 'package:flutter/material.dart';
import 'package:my_todo_app/model/task.dart';
import 'package:my_todo_app/model/task_list.dart';
import 'package:provider/provider.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  Priority _selectedValue = Priority.high;

  bool _isFormValid = false;

  void _checkFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Task"), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  // Title
                  TextFormField(
                    controller: titleController,
                    onChanged: (_) => _checkFormValidity(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Titel',
                      hintText: 'Mindestens 1 Zeichen',
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
                    onChanged: (_) => _checkFormValidity(),
                    maxLines: 10,
                    maxLength: 400,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Beschreibung',
                      hintText: 'Mindestens 1 Zeichen',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Bitte eine Beschreibung eingeben";
                      }
                      return null;
                    },
                  ),
                  DueTimeArea(
                    dayController: dayController,
                    monthController: monthController,
                    yearController: yearController,
                    onChanged: (_) => _checkFormValidity(),
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
                    ],
                  ),

                  ElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            int year = int.parse(yearController.text);
                            int month = int.parse(monthController.text);
                            int day = int.parse(dayController.text);
                            context.read<TaskList>().addTask(
                              Task(
                                title: titleController.text,
                                description: descriptionController.text,
                                dueDate: DateTime(year, month, day),
                                priority: _selectedValue,
                              ),
                            );
                            context.read<TaskList>().safeTaskList();
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text("Erstellen"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    titleController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
    dayController.value = TextEditingValue(text: "31");
    dayController.addListener(() => setState(() {}));
    monthController.value = TextEditingValue(text: "12");
    monthController.addListener(() => setState(() {}));
    yearController.value = TextEditingValue(text: "2050");
    yearController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }
}

class DueTimeArea extends StatelessWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final ValueChanged onChanged;
  const DueTimeArea({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text("Fälligkeitsdatum:"),
        ),
        Row(
          spacing: 5,
          children: [
            Expanded(
              child: TextFormField(
                controller: dayController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  labelText: "Tag",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bitte Wert eingeben";
                  }

                  final day = int.tryParse(value);
                  if (day == null || day < 1 || day > 31) {
                    return "Ungültig";
                  }

                  return null;
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: monthController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  labelText: "Monat",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                maxLength: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Fehlt";
                  }

                  final month = int.tryParse(value);
                  if (month == null || month < 1 || month > 12) {
                    return "Ungültig";
                  }

                  return null;
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: yearController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  labelText: "Jahr",
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Fehlt";
                  }

                  final year = int.tryParse(value);
                  if (year == null || year < DateTime.now().year) {
                    return "Ungültig";
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
