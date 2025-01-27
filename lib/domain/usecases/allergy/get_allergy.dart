import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/allergy.dart';
import 'package:nutrichild/domain/repositories/allergy_repository.dart';

class GetAllergy {
  final AllergyRepository _allergyRepository;

  GetAllergy(this._allergyRepository);

  Future<Either<Failure, List<Allergy>>> call(String id) async {
    return await _allergyRepository.getAllergybyChildId(id);
  }
}
