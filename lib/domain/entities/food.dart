import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;

  const Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, calories, protein, carbs, fat, imageUrl];
}
