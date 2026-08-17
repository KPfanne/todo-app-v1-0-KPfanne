import 'package:flutter/material.dart';

class FilterDropDown extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String?> onChanged;
  const FilterDropDown({
    super.key,
    required this.currentFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.center,
      items: [
        DropdownMenuItem(value: "Alle", child: Text("Alle")),
        DropdownMenuItem(value: "Erledigt", child: Text("Erledigt")),
        DropdownMenuItem(value: "Offen", child: Text("Offen")),
      ],
      onChanged: onChanged,
      value: currentFilter.isEmpty ? null : currentFilter,
    );
  }
}
