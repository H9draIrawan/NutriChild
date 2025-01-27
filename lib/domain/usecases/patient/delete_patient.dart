import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/repositories/patient_repository.dart';

class DeletePatient {
  final PatientRepository _patientRepository;

  DeletePatient(this._patientRepository);

  Future<Either<Failure, void>> call(String childId) async {
    return await _patientRepository.deletePatient(childId);
  }
}
