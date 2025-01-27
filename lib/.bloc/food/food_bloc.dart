import 'package:bloc/bloc.dart';
import 'package:nutrichild/.bloc/food/food_event.dart';
import 'package:nutrichild/.bloc/food/food_state.dart';

import '../../database/database_food.dart';
import '../../database/database_meal.dart';
import '../../.model/Food.dart';
import '../../.model/Meal.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodSqflite foodSqflite = FoodSqflite();
  final MealSqflite mealSqflite = MealSqflite();

  FoodBloc() : super(InitialBreakfastState()) {
    on<InitialBreakfastEvent>((event, emit) {
      emit(InitialBreakfastState());
    });

    on<InitialLunchEvent>((event, emit) {
      emit(InitialLunchState());
    });

    on<InitialDinnerEvent>((event, emit) {
      emit(InitialDinnerState());
    });

    on<SaveFoodEvent>((event, emit) async {
      await foodSqflite.insertFood(Food(
        id: event.food.id,
        name: event.food.name,
        calories: event.food.calories,
        protein: event.food.protein,
        carbs: event.food.carbs,
        fat: event.food.fat,
        imageUrl: event.food.imageUrl,
      ));

      try {
        await mealSqflite.insertMeal(
          Meal(
            id: event.meal.id,
            childId: event.meal.childId,
            foodId: event.food.id,
            mealTime: event.meal.mealTime,
            dateTime: event.meal.dateTime,
            qty: event.meal.qty,
          ),
        );
      } catch (e) {
        print(e);
      }
    });

    on<DeleteFoodEvent>((event, emit) async {
      await mealSqflite.deleteMealsByDate(event.childId, event.dateTime);
    });

    on<DeleteMealEvent>((event, emit) async {
      await mealSqflite.deleteMealbyChildId(event.childId);
    });
  }
}
