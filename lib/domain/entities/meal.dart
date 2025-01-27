import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String childId;
  final String foodId;
  final DateTime date;
  final DateTime time;
  final double quantity;

  const Meal({
    required this.id,
    required this.childId,
    required this.foodId,
    required this.date,
    required this.time,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, childId, foodId, date, time, quantity];
}
