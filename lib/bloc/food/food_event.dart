import 'package:equatable/equatable.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object> get props => [];
}

class InitialBreakfastEvent extends FoodEvent {}

class InitialLunchEvent extends FoodEvent {}

class InitialDinnerEvent extends FoodEvent {}

class BreakfastEvent extends FoodEvent {
  final String childId;
  final String foodName;
  final String imageUrl;
  final double calories;
  final int qty;

  const BreakfastEvent({
    required this.childId,
    required this.foodName,
    required this.imageUrl,
    required this.calories,
    required this.qty,
  });

  @override
  List<Object> get props => [childId, foodName, imageUrl, calories, qty];
}

class LunchEvent extends FoodEvent {
  final String childId;
  final String foodName;
  final String imageUrl;
  final double calories;
  final int qty;

  const LunchEvent({
    required this.childId,
    required this.foodName,
    required this.imageUrl,
    required this.calories,
    required this.qty,
  });

  @override
  List<Object> get props => [childId, foodName, imageUrl, calories, qty];
}

class DinnerEvent extends FoodEvent {
  final String childId;
  final String foodName;
  final String imageUrl;
  final double calories;
  final int qty;

  const DinnerEvent({
    required this.childId,
    required this.foodName,
    required this.imageUrl,
    required this.calories,
    required this.qty,
  });

  @override
  List<Object> get props => [childId, foodName, imageUrl, calories, qty];
}
