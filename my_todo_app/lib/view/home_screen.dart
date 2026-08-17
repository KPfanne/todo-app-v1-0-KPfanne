import 'package:flutter/material.dart';
import 'package:my_todo_app/model/task_list.dart';
import 'package:my_todo_app/theme/theme_notifier.dart';
import 'package:my_todo_app/view/settings_screen.dart';
import 'package:my_todo_app/view/task_create_screen.dart';
import 'package:my_todo_app/widget/filter_drop_down.dart';
import 'package:my_todo_app/widget/sort_tasks.dart';
import 'package:my_todo_app/widget/task_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskList>().loadTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("My Todo List"),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
                },
                icon: Icon(Icons.settings, size: 40),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 10,
                children: [
                  FilterArea(),
                  Consumer<TaskList>(
                    builder: (context, taskList, child) {
                      final tasks = taskList.getTasks(taskList.currentFilter);
                      if (tasks.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return TaskCard(task: tasks[index]);
                            },
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("Keine Aufgaben vorhanden"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.large(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskCreateScreen()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class FilterArea extends StatefulWidget {
  const FilterArea({super.key});

  @override
  State<FilterArea> createState() => _FilterAreaState();
}

class _FilterAreaState extends State<FilterArea> {
  Order? _chosenOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Filter: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  FilterDropDown(
                    currentFilter: context.watch<TaskList>().currentFilter,
                    onChanged: (newFilter) {
                      if (newFilter != null) {
                        context.read<TaskList>().setFilter(newFilter);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SortTasks(
                      label: "Asc",
                      chosenOrder: Order.ascending,
                      groupValue: _chosenOrder,
                      onChanged: (order) {
                        setState(() => _chosenOrder = order);
                        context.read<TaskList>().sortByAscending();
                      },
                    ),
                    SortTasks(
                      label: "Desc",
                      chosenOrder: Order.descending,
                      groupValue: _chosenOrder,
                      onChanged: (order) {
                        setState(() => _chosenOrder = order);
                        context.read<TaskList>().sortByDescending();
                      },
                    ),
                    SortTasks(
                      label: "Prio",
                      chosenOrder: Order.priority,
                      groupValue: _chosenOrder,
                      onChanged: (order) {
                        setState(() => _chosenOrder = order);
                        context.read<TaskList>().sortByPriority();
                      },
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SortTasks(
                      label: "Due",
                      chosenOrder: Order.dueDate,
                      groupValue: _chosenOrder,
                      onChanged: (order) {
                        setState(() => _chosenOrder = order);
                        context.read<TaskList>().sortByDueDate();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
