import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register(this.repository);

  Future<Either<Failure, void>> call(
    String email,
    String password,
    String username,
  ) {
    return repository.register(email, password, username);
  }
}
