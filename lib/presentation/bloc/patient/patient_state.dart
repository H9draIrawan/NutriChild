import 'package:equatable/equatable.dart';
import 'package:nutrichild/domain/entities/patient.dart';

abstract class PatientState extends Equatable {
  const PatientState();
}

class InitialPatientState extends PatientState {
  @override
  List<Object?> get props => [];
}

class LoadingPatientState extends PatientState {
  @override
  List<Object?> get props => [];
}

class LoadPatientState extends PatientState {
  final List<Patient> patients;

  const LoadPatientState({required this.patients});

  @override
  List<Object?> get props => [patients];
}

class AddPatientState extends PatientState {
  final Patient patient;

  const AddPatientState({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class DeletePatientState extends PatientState {
  final String childId;

  const DeletePatientState({required this.childId});

  @override
  List<Object?> get props => [childId];
}

class ErrorPatientState extends PatientState {
  final String message;

  const ErrorPatientState({required this.message});

  @override
  List<Object?> get props => [message];
}
