class Meal {
  final String id;
  final String childId;
  final String foodId;
  final String mealTime;
  final String dateTime;
  final int qty;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;

  Meal({
    required this.id,
    required this.childId,
    required this.foodId,
    required this.mealTime,
    required this.dateTime,
    required this.qty,
    this.name = '',
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'foodId': foodId,
      'mealTime': mealTime,
      'dateTime': dateTime,
      'qty': qty,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      childId: map['childId'],
      foodId: map['foodId'],
      mealTime: map['mealTime'],
      dateTime: map['dateTime'],
      qty: map['qty'],
      name: map['name'] ?? '',
      calories: map['calories'] ?? 0,
      protein: map['protein']?.toDouble() ?? 0.0,
      carbs: map['carbs']?.toDouble() ?? 0.0,
      fat: map['fat']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
