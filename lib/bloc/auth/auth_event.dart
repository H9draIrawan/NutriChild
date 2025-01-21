import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}

class LogoutEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final String username;
  final String email;

  const UpdateProfileEvent({
    required this.username,
    required this.email,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent(this.email);
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });
}

class DeleteAccountEvent extends AuthEvent {
  final String password;
  const DeleteAccountEvent({required this.password});
}
