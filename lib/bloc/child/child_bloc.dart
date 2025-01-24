import 'package:bloc/bloc.dart';
import 'package:nutrichild/model/child.dart';
import 'package:nutrichild/model/patient.dart';

import '../../database/database_child.dart';
import '../../database/database_allergy.dart';
import '../../database/database_patient.dart';

import 'child_event.dart';
import 'child_state.dart';

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final ChildSqflite childSqflite = ChildSqflite();
  final AllergySqflite allergySqflite = AllergySqflite();
  final PatientSqflite patientSqflite = PatientSqflite();

  ChildBloc() : super(InitialChildState()) {
    on<SaveChildEvent>((event, emit) async {
      final child = Child(
        id: event.id,
        userId: event.userId,
        name: event.name,
        age: event.age,
        gender: event.gender,
        weight: event.weight,
        height: event.height,
        goal: event.goal,
      );
      await childSqflite.insertChild(child);
      emit(LoadChildState(child));
    });

    on<SaveAllergyEvent>((event, emit) async {
      if (event.name != "") {
        final id = "A${DateTime.now().millisecondsSinceEpoch}";
        final allergyId = await allergySqflite.getAllergybyName(event.name);
        await patientSqflite.insertPatient(Patient(
          id: id,
          childId: event.childId,
          allergyId: allergyId,
        ));
      }
    });

    on<LoadChildEvent>((event, emit) async {
      emit(LoadingChildState());

      if (event.childId != null) {
        final child = await childSqflite.getChildById(event.childId!);
        emit(LoadChildState(child!));
      } else if (event.userId != null) {
        final children = await childSqflite.getChildByUserId(event.userId!);
        if (children.isNotEmpty) {
          emit(LoadChildState(children.first));
        } else {
          emit(ErrorChildState("Child not found"));
        }
      }
    });

    on<UpdateChildEvent>((event, emit) async {
      await childSqflite.updateChild(event.child);
      emit(LoadChildState(event.child));
    });

    on<DeleteAllergyEvent>((event, emit) async {
      await patientSqflite.deletePatientByChildId(event.childId);
    });

    on<DeleteChildEvent>((event, emit) async {
      await childSqflite.deleteChild(event.childId);
      await patientSqflite.deletePatientByChildId(event.childId);
    });
  }
}
