class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;
  final String youtube;
  final Map<String, String> ingredients;


  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
    required this.youtube,
    required this.ingredients,
  });

  //da se osigurame deka ne vlecime null vrednosti

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient\$i'];
      final measure = json['strMeasure\$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        ingredients[ing.toString()] = (measure ?? '').toString();
      }
    }
    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      youtube: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}