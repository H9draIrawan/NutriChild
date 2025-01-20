import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class LoginAuthState extends AuthState {
  final String id;
  final String username;
  final String email;

  const LoginAuthState(this.id, this.username, this.email);

  @override
  List<Object> get props => [id, username, email];
}

class RegisterAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateProfileSuccessState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {}

class ChangePasswordSuccessState extends AuthState {}

class DeleteAccountSuccessState extends AuthState {}

class EmailVerificationSentState extends AuthState {
  const EmailVerificationSentState();
}
