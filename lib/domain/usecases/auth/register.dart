import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class Register {
  final AuthRepository _authRepository;

  Register(this._authRepository);

  Future<Either<Failure, void>> call(
    String email,
    String password,
    String username,
  ) {
    return _authRepository.register(email, password, username);
  }
}
