import 'package:nutrichild/data/datasources/local/allergy_local_data_source.dart';
import 'package:nutrichild/domain/repositories/allergy_repository.dart';
import 'package:nutrichild/domain/entities/allergy.dart';
import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';

class AllergyRepositoryImpl implements AllergyRepository {
  final AllergyLocalDataSource allergyLocalDataSource;

  AllergyRepositoryImpl({
    required this.allergyLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> initDatabase() async {
    try {
      await allergyLocalDataSource.initDatabase();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Allergy>>> getAllergybyChildId(String id) async {
    try {
      final result = await allergyLocalDataSource.getAllergybyChildId(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
