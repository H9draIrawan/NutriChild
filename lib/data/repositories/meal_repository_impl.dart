import 'package:nutrichild/data/datasources/remote/meal_remote_data_source.dart';
import 'package:nutrichild/domain/repositories/meal_repository.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/meal.dart';
import 'package:dartz/dartz.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDataSource mealRemoteDataSource;

  MealRepositoryImpl({
    required this.mealRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Meal>>> getMeals() async {
    try {
      final meals = await mealRemoteDataSource.getMeals();
      return Right(meals);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meal>> addMeal(Meal meal) async {
    try {
      await mealRemoteDataSource.addMeal(meal);
      return Right(meal);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Meal>> updateMeal(Meal meal) async {
    try {
      await mealRemoteDataSource.updateMeal(meal);
      return Right(meal);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMeal(Meal meal) async {
    try {
      await mealRemoteDataSource.deleteMeal(meal);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
