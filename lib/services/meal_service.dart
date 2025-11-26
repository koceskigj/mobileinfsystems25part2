import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';


class MealService {
  static const base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = (data['categories'] as List).map((e) => Category.fromJson(e)).toList();
      return list;
    }
    throw Exception('Failed fetching categories');
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final res = await http.get(Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['meals'] == null) return [];
      final list = (data['meals'] as List).map((e) => Meal.fromJson(e)).toList();
      return list;
    }
    throw Exception('Failed fetching meals for category');
  }

  Future<List<Meal>> searchMeals(String query) async {
    final res = await http.get(Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['meals'] == null) return [];
      final list = (data['meals'] as List).map((e) => Meal.fromJson(e)).toList();
      return list;
    }
    throw Exception('Search failed');
  }

  Future<MealDetail> lookupMeal(String id) async {
    final res = await http.get(Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final jsonMeal = data['meals'][0];
      return MealDetail.fromJson(jsonMeal);
    }
    throw Exception('Lookup failed');
  }

  Future<MealDetail> randomMeal() async {
    final res = await http.get(Uri.parse('$base/random.php'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final jsonMeal = data['meals'][0];
      return MealDetail.fromJson(jsonMeal);
    }
    throw Exception('Random meal failed');
  }
}

final MealService mealService = MealService();