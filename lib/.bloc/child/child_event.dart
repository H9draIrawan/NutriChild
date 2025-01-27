import 'package:equatable/equatable.dart';
import '../../model/child.dart';
abstract class ChildEvent extends Equatable {
  const ChildEvent();
}

class SaveChildEvent extends ChildEvent {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String goal;

  const SaveChildEvent({
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
  List<Object> get props =>
      [id, userId, name, age, gender, weight, height, goal];
}

class SaveAllergyEvent extends ChildEvent {
  final String name;
  final String childId;

  const SaveAllergyEvent({required this.name, required this.childId});

  @override
  List<Object> get props => [name, childId];
}

class LoadChildEvent extends ChildEvent {
  final String? childId;
  final String? userId;

  const LoadChildEvent({this.childId, this.userId});

  @override
  List<Object?> get props => [childId, userId];
}

class UpdateChildEvent extends ChildEvent {
  final Child child;

  const UpdateChildEvent(this.child);

  @override
  List<Object> get props => [child];
}

class DeleteAllergyEvent extends ChildEvent {
  final String childId;

  const DeleteAllergyEvent(this.childId);

  @override
  List<Object> get props => [childId];
}

class DeleteChildEvent extends ChildEvent {
  final String childId;

  const DeleteChildEvent(this.childId);

  @override
  List<Object> get props => [childId];
}
