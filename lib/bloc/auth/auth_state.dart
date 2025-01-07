import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoginAuthState extends AuthState {
  final String username;
  final String email;

  const LoginAuthState(this.username, this.email);

  @override
  List<Object> get props => [username, email];
}

class RegisterAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object> get props => [message];
}
