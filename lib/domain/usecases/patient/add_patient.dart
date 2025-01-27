import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/patient.dart';
import 'package:nutrichild/domain/repositories/patient_repository.dart';

class AddPatient {
  final PatientRepository _patientRepository;

  AddPatient(this._patientRepository);

  Future<Either<Failure, void>> call(Patient patient) async {
    return await _patientRepository.addPatient(patient);
  }
}
