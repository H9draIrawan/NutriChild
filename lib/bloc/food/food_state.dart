import 'package:equatable/equatable.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

class InitialBreakfastState extends FoodState {}

class InitialLunchState extends FoodState {}

class InitialDinnerState extends FoodState {}
