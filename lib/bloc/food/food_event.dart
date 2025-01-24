import 'package:equatable/equatable.dart';
import 'package:nutrichild/model/Food.dart';
import 'package:nutrichild/model/Meal.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object> get props => [];
}

class InitialBreakfastEvent extends FoodEvent {}

class InitialLunchEvent extends FoodEvent {}

class InitialDinnerEvent extends FoodEvent {}

class SaveFoodEvent extends FoodEvent {
  final Food food;
  final Meal meal;

  const SaveFoodEvent({required this.food, required this.meal});

  @override
  List<Object> get props => [food, meal];
}

class DeleteFoodEvent extends FoodEvent {
  final String childId;
  final String dateTime;

  const DeleteFoodEvent(this.childId, this.dateTime);

  @override
  List<Object> get props => [childId, dateTime];
}

class DeleteMealEvent extends FoodEvent {
  final String childId;

  const DeleteMealEvent(this.childId);

  @override
  List<Object> get props => [childId];
}
