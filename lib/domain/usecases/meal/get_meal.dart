import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/meal.dart';
import 'package:nutrichild/domain/repositories/meal_repository.dart';

class GetMeal {
  final MealRepository _mealRepository;

  GetMeal(this._mealRepository);

  Future<Either<Failure, List<Meal>>> call() async {
    return await _mealRepository.getMeals();
  }
}
