import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/domain/usecases/patient/get_patient.dart';
import 'package:nutrichild/domain/usecases/patient/add_patient.dart';
import 'package:nutrichild/domain/usecases/patient/delete_patient.dart';
import 'package:nutrichild/domain/entities/patient.dart';
import 'package:nutrichild/presentation/bloc/patient/patient_event.dart';
import 'package:nutrichild/presentation/bloc/patient/patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final GetPatient _getPatient;
  final AddPatient _addPatient;
  final DeletePatient _deletePatient;

  PatientBloc(
      {required GetPatient getPatient,
      required AddPatient addPatient,
      required DeletePatient deletePatient})
      : _getPatient = getPatient,
        _addPatient = addPatient,
        _deletePatient = deletePatient,
        super(InitialPatientState()) {
    on<GetPatientEvent>(_onGetPatient);
    on<AddPatientEvent>(_onAddPatient);
    on<DeletePatientEvent>(_onDeletePatient);
  }

  void _onGetPatient(event, emit) async {
    emit(LoadingPatientState());
    final result = await _getPatient(event.childId);
    result.fold(
        (failure) => emit(ErrorPatientState(message: failure.toString())),
        (patients) => emit(LoadPatientState(patients: patients)));
  }

  void _onAddPatient(event, emit) async {
    emit(LoadingPatientState());
    final result = await _addPatient(event.patient);
    result.fold(
        (failure) => emit(ErrorPatientState(message: failure.toString())),
        (_) => emit(AddPatientState(patient: event.patient)));
  }

  void _onDeletePatient(event, emit) async {
    emit(LoadingPatientState());
    final result = await _deletePatient(event.childId);
    result.fold(
        (failure) => emit(ErrorPatientState(message: failure.toString())),
        (_) => emit(DeletePatientState(childId: event.childId)));
  }
}
