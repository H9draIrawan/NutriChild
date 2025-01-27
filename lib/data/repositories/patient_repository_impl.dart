import 'package:nutrichild/data/datasources/remote/patient_remote_data_source.dart';
import 'package:nutrichild/domain/entities/patient.dart';
import 'package:dartz/dartz.dart';
import 'package:nutrichild/core/error/failures.dart';
import 'package:nutrichild/domain/repositories/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource patientRemoteDataSource;

  PatientRepositoryImpl({
    required this.patientRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Patient>>> getPatients(String childId) async {
    try {
      final result = await patientRemoteDataSource.getPatients(childId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPatient(Patient patient) async {
    try {
      await patientRemoteDataSource.addPatient(patient);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePatient(String childId) async {
    try {
      await patientRemoteDataSource.deletePatient(childId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
