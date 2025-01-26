import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [properties];
}

// General Failures
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserNotFoundFailure extends Failure {
  final String message;

  const UserNotFoundFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailNotVerifiedFailure extends Failure {
  final String message;

  const EmailNotVerifiedFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserAlreadyExistsFailure extends Failure {
  final String message;

  const UserAlreadyExistsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
