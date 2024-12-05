import 'package:flutter/material.dart';

Widget customDropdown(
  BuildContext context, {
  required List<String> options,
  required Function(String?) onChanged,
  required String selectedValue,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: DropdownButton<String>(
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      isExpanded: true,
      underline: const SizedBox(),
      onChanged: onChanged,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ),
  );
}
