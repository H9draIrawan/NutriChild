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
}
