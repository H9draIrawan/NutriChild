import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/allergy.dart';

abstract interface class AllergyRepository {
  Future<Either<Failure, void>> initDatabase();
  Future<Either<Failure, List<Allergy>>> getAllergybyChildId(String id);
}
