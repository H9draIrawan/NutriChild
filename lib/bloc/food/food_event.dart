import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object> get props => [];
}

class InitialBreakfastEvent extends FoodEvent {}

class InitialLunchEvent extends FoodEvent {}

class InitialDinnerEvent extends FoodEvent {}

class SaveFoodEvent extends FoodEvent {
  final String childId;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final String mealTime;
  final int qty;
  final DateTime dateTime;

  const SaveFoodEvent(
      {required this.childId,
      required this.foodName,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat,
      required this.imageUrl,
      required this.mealTime,
      required this.qty,
      required this.dateTime});

  @override
  List<Object> get props => [
        childId,
        foodName,
        calories,
        protein,
        carbs,
        fat,
        imageUrl,
        mealTime,
        qty,
        dateTime
      ];
}

class GetFoodEvent extends FoodEvent {
  final String childId;
  final String mealTime;

  const GetFoodEvent({required this.childId, required this.mealTime});

  @override
  List<Object> get props => [childId, mealTime];
}

class DeleteFoodEvent extends FoodEvent {
  final String mealId;

  const DeleteFoodEvent({required this.mealId});

  @override
  List<Object> get props => [mealId];
}

class UpdateFoodEvent extends FoodEvent {
  final String mealId;
  final String foodName;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final int qty;
  final DateTime dateTime;

  const UpdateFoodEvent(
      {required this.mealId,
      required this.foodName,
      required this.calories,
      required this.protein,
      required this.carbs,
      required this.fat,
      required this.imageUrl,
      required this.qty,
      required this.dateTime});

  @override
  List<Object> get props => [
        mealId,
        foodName,
        calories,
        protein,
        carbs,
        fat,
        imageUrl,
        qty,
        dateTime
      ];
}
