import 'package:equatable/equatable.dart';

class Child extends Equatable {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String goal;

  const Child({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.goal,
  });

  @override
  List<Object?> get props =>
      [id, userId, name, age, gender, weight, height, goal];
}
