import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/child.dart';

abstract interface class ChildRepository {
  Future<Either<Failure, List<Child>>> get(String userId);
  Future<Either<Failure, void>> add(Child child);
  Future<Either<Failure, void>> update(Child child);
  Future<Either<Failure, void>> delete(Child child);
}
