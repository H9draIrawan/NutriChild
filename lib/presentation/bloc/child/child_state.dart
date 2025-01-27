import 'package:equatable/equatable.dart';
import '../../../domain/entities/child.dart';

abstract class ChildState extends Equatable {
  const ChildState();

  @override
  List<Object?> get props => [];
}

class InitialChildState extends ChildState {}

class LoadingChildState extends ChildState {}

class LoadChildState extends ChildState {
  final Child child;

  const LoadChildState({required this.child});

  @override
  List<Object?> get props => [child];
}

class ErrorChildState extends ChildState {
  final String message;

  const ErrorChildState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddChildState extends ChildState {}

class UpdateChildState extends ChildState {}

class DeleteChildState extends ChildState {}
