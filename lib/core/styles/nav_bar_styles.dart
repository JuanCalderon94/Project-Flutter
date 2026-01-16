import 'package:flutter/material.dart';

class AppCategoryBar {
  static Widget categoryFilterBar({
    required List<String> categories,
    required int selected,
    required ValueChanged<int> onSelected,
  }) {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(categories[index]),
                selected: selected == index,
                onSelected: (bool value) {
                  if (value) onSelected(index);
                },
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: selected == index ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}