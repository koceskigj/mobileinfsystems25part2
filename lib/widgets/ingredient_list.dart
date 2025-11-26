import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final Map<String, String> ingredients;

  const IngredientList({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) return Text('No ingredients found');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text('- ${entry.key} : ${entry.value}'),
        );
      }).toList(),
    );
  }
}