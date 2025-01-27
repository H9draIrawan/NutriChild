import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/meal.dart';
import 'package:nutrichild/domain/repositories/meal_repository.dart';

class DeleteMeal {
  final MealRepository _mealRepository;

  DeleteMeal(this._mealRepository);

  Future<Either<Failure, void>> call(Meal meal) async {
    return await _mealRepository.deleteMeal(meal);
  }
}
