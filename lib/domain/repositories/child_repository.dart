import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/child.dart';

abstract interface class ChildRepository {
  Future<Either<Failure, void>> add(Child child);
  Future<Either<Failure, void>> update(Child child);
  Future<Either<Failure, void>> delete(Child child);
}
