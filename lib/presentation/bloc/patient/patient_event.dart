import 'package:equatable/equatable.dart';
import 'package:nutrichild/domain/entities/patient.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();
}

class GetPatientEvent extends PatientEvent {
  final String childId;

  const GetPatientEvent({required this.childId});

  @override
  List<Object?> get props => [childId];
}

class AddPatientEvent extends PatientEvent {
  final Patient patient;

  const AddPatientEvent({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class DeletePatientEvent extends PatientEvent {
  final String childId;

  const DeletePatientEvent({required this.childId});

  @override
  List<Object?> get props => [childId];
}
