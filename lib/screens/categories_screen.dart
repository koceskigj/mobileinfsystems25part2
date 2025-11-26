import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_service.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = mealService.fetchCategories();
  }

  void _openRandom() async {
    try {
      final meal = await mealService.randomMeal();
      print('Random meal ID: ${meal.id}');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load random meal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            onPressed: _openRandom,
            icon: Icon(Icons.casino),
            tooltip: 'Random recipe',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search categories',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(child: CircularProgressIndicator());

                if (snapshot.hasError)
                  return Center(child: Text('Error loading categories'));

                final allCategories = snapshot.data ?? [];

                final filtered = _query.isEmpty
                    ? allCategories
                    : allCategories
                    .where((c) => c.name
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
                    .toList();

                if (filtered.isEmpty)
                  return Center(child: Text('No categories found'));

                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filtered.length,
                  itemBuilder: (context, idx) {
                    final cat = filtered[idx];
                    return CategoryCard(
                      category: cat,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Meal screen is not implemented yet.')));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
