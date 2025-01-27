import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/repositories/allergy_repository.dart';

class InitAllergy {
  final AllergyRepository _allergyRepository;

  InitAllergy(this._allergyRepository);

  Future<Either<Failure, void>> call() async {
    return await _allergyRepository.initDatabase();
  }
}
