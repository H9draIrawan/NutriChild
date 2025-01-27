import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await authRemoteDataSource.login(email, password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> register(
      String email, String password, String username) async {
    try {
      final result =
          await authRemoteDataSource.register(email, password, username);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await authRemoteDataSource.logout();
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    final result = await authRemoteDataSource.resetPassword(email);
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String email, String password) async {
    final result = await authRemoteDataSource.changePassword(email, password);
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> updateUser(User user) async {
    final result = await authRemoteDataSource.updateUser(user as UserModel);
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    final result = await authRemoteDataSource.deleteAccount();
    return Right(result);
  }
}
