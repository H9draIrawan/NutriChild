import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on UserNotFoundException catch (e) {
      return Left(UserNotFoundFailure(e.message));
    } on EmailNotVerifiedException catch (e) {
      return Left(EmailNotVerifiedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> register(
      String email, String password, String username) async {
    try {
      final result = await remoteDataSource.register(email, password, username);
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on UserAlreadyExistsException catch (e) {
      return Left(UserAlreadyExistsFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    final result = await remoteDataSource.logout();
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    final result = await remoteDataSource.resetPassword(email);
    return Right(result);
  }
}
