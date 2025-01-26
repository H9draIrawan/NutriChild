import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoginAuthState extends AuthState {
  final User user;

  const LoginAuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterAuthState extends AuthState {
  const RegisterAuthState();
}

class ErrorAuthState extends AuthState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutAuthState extends AuthState {
  const LogoutAuthState();
}

class ResetPasswordAuthState extends AuthState {
  const ResetPasswordAuthState();
}
