import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/meal.dart';

abstract interface class MealRepository {
  Future<Either<Failure, List<Meal>>> getMeals();
  Future<Either<Failure, Meal>> addMeal(Meal meal);
  Future<Either<Failure, Meal>> updateMeal(Meal meal);
  Future<Either<Failure, void>> deleteMeal(Meal meal);
}
