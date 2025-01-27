import 'package:nutrichild/domain/entities/meal.dart';

class MealModel extends Meal {
  const MealModel({
    required super.id,
    required super.childId,
    required super.foodId,
    required super.date,
    required super.time,
    required super.quantity,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'],
      childId: json['childId'],
      foodId: json['foodId'],
      date: json['date'],
      time: json['time'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'foodId': foodId,
      'date': date,
      'time': time,
      'quantity': quantity,
    };
  }
}
