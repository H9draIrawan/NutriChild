import 'package:nutrichild/domain/entities/food.dart';

class FoodModel extends Food {
  const FoodModel({
    required super.id,
    required super.name,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
    };
  }
}
