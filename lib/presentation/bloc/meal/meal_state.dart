import 'package:nutrichild/domain/entities/meal.dart';

abstract class MealState {}

class InitialMealState extends MealState {}

class LoadingMealState extends MealState {}

class LoadMealState extends MealState {
  final List<Meal> meals;

  LoadMealState({required this.meals});
}

class ErrorMealState extends MealState {
  final String message;

  ErrorMealState({required this.message});
}

class AddMealState extends MealState {}

class UpdateMealState extends MealState {}

class DeleteMealState extends MealState {}
