import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/meal.dart';
import 'package:nutrichild/domain/repositories/meal_repository.dart';

class UpdateMeal {
  final MealRepository _mealRepository;

  UpdateMeal(this._mealRepository);

  Future<Either<Failure, void>> call(Meal meal) async {
    return await _mealRepository.updateMeal(meal);
  }
}
