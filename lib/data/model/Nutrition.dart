class Nutrition {
  late int? id;
  late String? name;
  late double? calories;
  late double? fat;
  late double? protein;
  late double? carbohydrates;

  Nutrition(
      {this.name, this.calories, this.fat, this.protein, this.carbohydrates});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbohydrates': carbohydrates,
    };
  }

  Nutrition.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    calories = map['calories'];
    fat = map['fat'];
    protein = map['protein'];
    carbohydrates = map['carbohydrates'];
  }
}
