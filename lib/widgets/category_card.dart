import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Image.network(category.thumb, width: 64, height: 64, fit: BoxFit.cover),
        title: Text(category.name),
        subtitle: Text(category.description.length > 80
            ? category.description.substring(0, 80) + '...'
            : category.description),
        onTap: onTap,
      ),
    );
  }
}
