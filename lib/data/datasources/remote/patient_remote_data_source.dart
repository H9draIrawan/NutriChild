import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrichild/core/error/exceptions.dart';
import 'package:nutrichild/domain/entities/patient.dart';
import 'package:nutrichild/data/models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<Patient>> getPatients(String childId);
  Future<void> addPatient(Patient patient);
  Future<void> deletePatient(String childId);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final FirebaseFirestore _firestore;

  PatientRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<List<Patient>> getPatients(String childId) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .where('childId', isEqualTo: childId)
          .get();
      return snapshot.docs
          .map((doc) => PatientModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addPatient(Patient patient) async {
    try {
      await _firestore
          .collection('patients')
          .add((patient as PatientModel).toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePatient(String childId) async {
    try {
      await _firestore
          .collection('patients')
          .where('childId', isEqualTo: childId)
          .get()
          .then((value) => value.docs.forEach((doc) => doc.reference.delete()));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
