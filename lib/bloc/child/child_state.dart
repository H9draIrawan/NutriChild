import 'package:equatable/equatable.dart';

import '../../model/child.dart';

abstract class ChildState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialChildState extends ChildState {}

class LoadChildState extends ChildState {
  final Child child;
  LoadChildState(this.child);
  @override
  List<Object> get props => [child];
}

class LoadingChildState extends ChildState {}

class ErrorChildState extends ChildState {
  final String message;
  ErrorChildState(this.message);
  @override
  List<Object> get props => [message];
}