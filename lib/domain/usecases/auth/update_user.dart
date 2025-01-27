import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';

class UpdateUser {
  final AuthRepository repository;

  UpdateUser(this.repository);

  Future<Either<Failure, void>> call(User user) async {
    return await repository.updateUser(user);
  }
}
