class Recipe {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final NutritionInfo nutritionInfo;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.nutritionInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      ingredients: _extractIngredients(json),
      instructions: (json['strInstructions'] ?? '')
          .split('\r\n')
          .where((step) => step.trim().isNotEmpty)
          .toList(),
      nutritionInfo: NutritionInfo.fromJson(json),
    );
  }

  static List<String> _extractIngredients(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add('${measure?.trim() ?? ''} ${ingredient.trim()}');
      }
    }
    return ingredients;
  }
}

class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
      fat: json['fat']?.toDouble() ?? 0.0,
    );
  }
}
