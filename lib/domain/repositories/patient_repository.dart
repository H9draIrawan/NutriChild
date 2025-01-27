import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/entities/patient.dart';

abstract interface class PatientRepository {
  Future<Either<Failure, List<Patient>>> getPatients(String childId);
  Future<Either<Failure, void>> addPatient(Patient patient);
  Future<Either<Failure, void>> deletePatient(String childId);
}
