import 'package:dartz/dartz.dart';
import 'package:nutrichild/domain/repositories/child_repository.dart';
import 'package:nutrichild/domain/entities/child.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/data/datasources/remote/child_remote_data_source.dart';

class ChildRepositoryImpl implements ChildRepository {
  final ChildRemoteDataSource childRemoteDataSource;

  ChildRepositoryImpl({
    required this.childRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Child>>> get(String userId) async {
    try {
      final children = await childRemoteDataSource.get(userId);
      return Right(children);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> add(Child child) async {
    try {
      await childRemoteDataSource.add(child);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> update(Child child) async {
    try {
      await childRemoteDataSource.update(child);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(Child child) async {
    try {
      await childRemoteDataSource.delete(child);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
