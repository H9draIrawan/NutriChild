import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository _authRepository;

  ResetPassword(this._authRepository);

  Future<Either<Failure, void>> call(String email) {
    return _authRepository.resetPassword(email);
  }
}
