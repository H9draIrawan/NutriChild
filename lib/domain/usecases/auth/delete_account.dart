import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';

class DeleteAccount {
  final AuthRepository _authRepository;

  DeleteAccount(this._authRepository);

  Future<Either<Failure, void>> call() async {
    return await _authRepository.deleteAccount();
  }
}
