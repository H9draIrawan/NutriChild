import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/patient.dart';
import 'package:nutrichild/domain/repositories/patient_repository.dart';

class GetPatient {
  final PatientRepository _patientRepository;

  GetPatient(this._patientRepository);

  Future<Either<Failure, List<Patient>>> call(String childId) async {
    return await _patientRepository.getPatients(childId);
  }
}
