import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> register(
    String email,
    String password,
    String username,
  );
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> resetPassword(String email);
}
