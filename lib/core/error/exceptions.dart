class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);
}

class EmailNotVerifiedException implements Exception {
  final String message;

  EmailNotVerifiedException(this.message);
}

class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException(this.message);
}
