import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}

class LogoutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});
}

class ChangePasswordEvent extends AuthEvent {
  final String email;
  final String password;

  const ChangePasswordEvent({required this.email, required this.password});
}

class UpdateUserEvent extends AuthEvent {
  final User user;

  const UpdateUserEvent({required this.user});
}

class DeleteAccountEvent extends AuthEvent {}
