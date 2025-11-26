import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import '../services/meal_service.dart';
import '../widgets/ingredient_list.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = mealService.lookupMeal(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe')),
      body: FutureBuilder<MealDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error loading recipe'));

          final meal = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(meal.thumb, height: 220, fit: BoxFit.cover),
                SizedBox(height: 8),

                Text(meal.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),

                Text('${meal.category} • ${meal.area}'),
                SizedBox(height: 12),

                Text('Instructions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                Text(meal.instructions),
                SizedBox(height: 12),

                Text('Ingredients',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(height: 6),
                IngredientList(ingredients: meal.ingredients),
                SizedBox(height: 12),

                if (meal.youtube.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(meal.youtube);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cannot open YouTube link')),
                        );
                      }
                    },
                    icon: Icon(Icons.play_circle_fill),
                    label: Text('Watch on YouTube'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}