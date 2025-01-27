import 'package:equatable/equatable.dart';

import '../../model/child.dart';

abstract class ChildState extends Equatable {
  const ChildState();

  @override
  List<Object> get props => [];
}

class InitialChildState extends ChildState {}

class LoadingChildState extends ChildState {}

class LoadChildState extends ChildState {
  final Child child;

  const LoadChildState(this.child);

  @override
  List<Object> get props => [child];
}

class NoChildState extends ChildState {}

class ErrorChildState extends ChildState {
  final String message;

  const ErrorChildState(this.message);

  @override
  List<Object> get props => [message];
}
