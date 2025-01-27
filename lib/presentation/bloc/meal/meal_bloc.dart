import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrichild/presentation/bloc/meal/meal_event.dart';
import 'package:nutrichild/presentation/bloc/meal/meal_state.dart';
import 'package:nutrichild/domain/usecases/meal/add_meal.dart';
import 'package:nutrichild/domain/usecases/meal/delete_meal.dart';
import 'package:nutrichild/domain/usecases/meal/get_meal.dart';
import 'package:nutrichild/domain/usecases/meal/update_meal.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final GetMeal _getMeal;
  final AddMeal _addMeal;
  final UpdateMeal _updateMeal;
  final DeleteMeal _deleteMeal;

  MealBloc({
    required GetMeal getMeal,
    required AddMeal addMeal,
    required UpdateMeal updateMeal,
    required DeleteMeal deleteMeal,
  })  : _getMeal = getMeal,
        _addMeal = addMeal,
        _updateMeal = updateMeal,
        _deleteMeal = deleteMeal,
        super(InitialMealState()) {
    on<GetMealEvent>(_onGetMeal);
    on<AddMealEvent>(_onAddMeal);
    on<UpdateMealEvent>(_onUpdateMeal);
    on<DeleteMealEvent>(_onDeleteMeal);
  }

  void _onGetMeal(event, emit) async {
    emit(LoadingMealState());
    final result = await _getMeal.call();
    result.fold((failure) => emit(ErrorMealState(message: failure.toString())),
        (meals) => emit(LoadMealState(meals: meals)));
  }

  void _onAddMeal(event, emit) async {
    emit(LoadingMealState());
    final result = await _addMeal.call(event.meal);
    result.fold((failure) => emit(ErrorMealState(message: failure.toString())),
        (_) => emit(AddMealState()));
  }

  void _onUpdateMeal(event, emit) async {
    emit(LoadingMealState());
    final result = await _updateMeal.call(event.meal);
    result.fold((failure) => emit(ErrorMealState(message: failure.toString())),
        (_) => emit(UpdateMealState()));
  }

  void _onDeleteMeal(event, emit) async {
    emit(LoadingMealState());
    final result = await _deleteMeal.call(event.meal);
    result.fold((failure) => emit(ErrorMealState(message: failure.toString())),
        (_) => emit(DeleteMealState()));
  }
}
