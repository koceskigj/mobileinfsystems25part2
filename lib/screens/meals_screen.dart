import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  MealsScreen({required this.category});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Future<List<Meal>> _future;
  List<Meal> _all = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    _future = mealService.fetchMealsByCategory(widget.category);

    _future.then((value) {
      setState(() {
        _all = value;
      });
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final displayed = _query.isEmpty
        ? _all
        : _all.where((m) => m.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search meals in this category'),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: displayed.isEmpty
                ? _all.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Center(child: Text('No meals found'))
                : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              itemCount: displayed.length,
              itemBuilder: (context, idx) {
                final meal = displayed[idx];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(mealId: meal.id),
                      ),
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
