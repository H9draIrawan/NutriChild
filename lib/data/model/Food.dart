class Food {
  late String? id;
  late String? name;
  late double? calories;
  late double? fat;
  late double? protein;
  late double? carbohydrates;

  Food(
      {required this.id,
      required this.name,
      required this.calories,
      required this.fat,
      required this.protein,
      required this.carbohydrates});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbohydrates': carbohydrates,
    };
  }

  Food.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    calories = map['calories'];
    fat = map['fat'];
    protein = map['protein'];
    carbohydrates = map['carbohydrates'];
  }
}
