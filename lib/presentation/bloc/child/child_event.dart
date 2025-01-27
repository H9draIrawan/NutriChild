import 'package:equatable/equatable.dart';
import '../../../domain/entities/child.dart';

abstract class ChildEvent extends Equatable {
  const ChildEvent();

  @override
  List<Object?> get props => [];
}

class AddChildEvent extends ChildEvent {
  final Child child;

  const AddChildEvent({required this.child});

  @override
  List<Object?> get props => [child];
}

class UpdateChildEvent extends ChildEvent {
  final Child child;

  const UpdateChildEvent({required this.child});
}

class DeleteChildEvent extends ChildEvent {
  final Child child;

  const DeleteChildEvent({required this.child});
}
