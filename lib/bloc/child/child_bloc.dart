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
        final id = "ALLERGY${DateTime.now().millisecondsSinceEpoch}";
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
      try {
        if (event.childId != null) {
          final child = await childSqflite.getChildById(event.childId!);
          if (child != null) {
            emit(LoadChildState(child));
          }
        } else if (event.userId != null) {
          final children = await childSqflite.getChildByUserId(event.userId!);
          if (children.isNotEmpty) {
            emit(LoadChildState(children.first));
          }
        }
      } catch (e) {
        emit(ErrorChildState(e.toString()));
      }
    });

    on<UpdateChildEvent>((event, emit) async {
      await childSqflite.updateChild(event.child);
      emit(LoadChildState(event.child));
    });

    on<DeleteAllergyEvent>((event, emit) async {
      await patientSqflite.deletePatientByChildId(event.childId);
    });
  }
}
