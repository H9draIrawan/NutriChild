import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class ChangePassword {
  final AuthRepository _authRepository;

  ChangePassword(this._authRepository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await _authRepository.changePassword(email, password);
  }
}
