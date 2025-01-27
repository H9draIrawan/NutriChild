import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class Logout {
  final AuthRepository _authRepository;

  Logout(this._authRepository);

  Future<Either<Failure, void>> call() {
    return _authRepository.logout();
  }
} 