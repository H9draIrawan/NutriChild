import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoadedAuthState extends AuthState {}

class AuthenticatedAuthState extends AuthState {}

class UnauthenticatedAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object> get props => [message];
}
