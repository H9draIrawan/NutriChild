import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class Login {
  final AuthRepository _authRepository;

  Login(this._authRepository);

  Future<Either<Failure, User>> call(String email, String password) {
    return _authRepository.login(email, password);
  }
}
