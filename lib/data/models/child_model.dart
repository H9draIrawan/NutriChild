import 'package:nutrichild/domain/entities/child.dart';

class ChildModel extends Child {
  const ChildModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.age,
    required super.gender,
    required super.weight,
    required super.height,
    required super.goal,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      weight: json['weight'],
      height: json['height'],
      goal: json['goal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}
