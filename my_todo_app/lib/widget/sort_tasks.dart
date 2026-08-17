import 'package:flutter/material.dart';

enum Order { ascending, descending, recency, priority, dueDate }

class SortTasks extends StatefulWidget {
  final String label;
  final Order chosenOrder;
  final Order? groupValue;
  final ValueChanged<Order?> onChanged;

  const SortTasks({
    super.key,
    required this.onChanged,
    this.groupValue,
    required this.chosenOrder,
    required this.label,
  });

  @override
  State<SortTasks> createState() => _SortTasksState();
}

class _SortTasksState extends State<SortTasks> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Order>(
          value: widget.chosenOrder,
          groupValue: widget.groupValue,
          onChanged: widget.onChanged,
        ),
        Text(widget.label),
      ],
    );
  }
}
