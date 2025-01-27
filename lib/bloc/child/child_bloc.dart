import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nutrichild/model/child.dart';
import 'package:nutrichild/model/patient.dart';

import '../../database/database_interface.dart';
import '../../database/database_child.dart';
import '../../database/database_allergy.dart';
import '../../database/database_patient.dart';

import 'child_event.dart';
import 'child_state.dart';

class ChildBloc extends Bloc<ChildEvent, ChildState> {
  final _database = DatabaseFactory.getDatabase();
  final ChildSqflite childSqflite = ChildSqflite();
  final AllergySqflite allergySqflite = AllergySqflite();
  final PatientSqflite patientSqflite = PatientSqflite();

  ChildBloc() : super(InitialChildState()) {
    on<SaveChildEvent>((event, emit) async {
      try {
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

        if (!kIsWeb) {
          // Only attempt to save to SQLite on non-web platforms
          await childSqflite.insertChild(child);
        }

        emit(LoadChildState(child));
      } catch (e) {
        emit(ErrorChildState("Failed to save child: $e"));
      }
    });

    on<SaveAllergyEvent>((event, emit) async {
      try {
        if (event.name.isNotEmpty) {
          final id = "A${DateTime.now().millisecondsSinceEpoch}";
          final allergyId = await allergySqflite.getAllergybyName(event.name);
          if (allergyId.isNotEmpty) {
            await patientSqflite.insertPatient(Patient(
              id: id,
              childId: event.childId,
              allergyId: allergyId,
            ));
          }
        }
      } catch (e) {
        emit(ErrorChildState("Failed to save allergy: $e"));
      }
    });

    on<LoadChildEvent>((event, emit) async {
      try {
        emit(LoadingChildState());

        if (event.childId != null) {
          final child = await childSqflite.getChildById(event.childId!);
          if (child != null) {
            emit(LoadChildState(child));
          } else {
            emit(NoChildState());
          }
        } else if (event.userId != null) {
          final children = await childSqflite.getChildByUserId(event.userId!);
          if (children.isNotEmpty) {
            emit(LoadChildState(children.first));
          } else {
            emit(NoChildState());
          }
        } else {
          emit(NoChildState());
        }
      } catch (e) {
        emit(ErrorChildState("Failed to load child: $e"));
      }
    });

    on<UpdateChildEvent>((event, emit) async {
      try {
        await childSqflite.updateChild(event.child);
        emit(LoadChildState(event.child));
      } catch (e) {
        emit(ErrorChildState("Failed to update child: $e"));
      }
    });

    on<DeleteAllergyEvent>((event, emit) async {
      try {
        await patientSqflite.deletePatientByChildId(event.childId);
      } catch (e) {
        emit(ErrorChildState("Failed to delete allergy: $e"));
      }
    });

    on<DeleteChildEvent>((event, emit) async {
      try {
        await childSqflite.deleteChild(event.childId);
        await patientSqflite.deletePatientByChildId(event.childId);
        emit(NoChildState());
      } catch (e) {
        emit(ErrorChildState("Failed to delete child: $e"));
      }
    });

    on<LoadChildByUserIdEvent>((event, emit) async {
      try {
        if (event.userId.isEmpty) {
          emit(const ErrorChildState("User ID cannot be empty"));
          return;
        }

        emit(LoadingChildState());
        final children = await _database.getChildByUserId(event.userId);

        if (children.isNotEmpty) {
          emit(LoadChildState(children.first));
        } else {
          emit(NoChildState());
        }
      } catch (e) {
        print("Error loading child: $e");
        emit(const ErrorChildState("Failed to load child data"));
      }
    });
  }
}
