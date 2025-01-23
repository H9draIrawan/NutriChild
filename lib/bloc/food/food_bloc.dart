import 'package:bloc/bloc.dart';
import 'package:nutrichild/bloc/food/food_event.dart';
import 'package:nutrichild/bloc/food/food_state.dart';

import '../../database/database_food.dart';
import '../../database/database_meal.dart';
import '../../model/Food.dart';
import '../../model/Meal.dart';

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
      final foodId = "F${DateTime.now().millisecondsSinceEpoch}";
      final mealId = "M${DateTime.now().millisecondsSinceEpoch}";

      await foodSqflite.insertFood(Food(
        id: foodId,
        name: event.foodName,
        calories: event.calories,
        protein: event.protein,
        carbs: event.carbs,
        fat: event.fat,
        imageUrl: event.imageUrl,
      ));

      await mealSqflite.insertMeal(
        Meal(
          id: mealId,
          childId: event.childId,
          foodId: foodId,
          mealTime: event.mealTime,
          dateTime:
              "${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year}",
          qty: event.qty,
        ),
      );
    });

    on<DeleteFoodEvent>((event, emit) async {
      final meals =
          await mealSqflite.getMealsByDate(event.childId, event.dateTime);
      for (var meal in meals) {
        await foodSqflite.deleteFoodById(meal.foodId);
      }
      await mealSqflite.deleteMealsByDate(event.childId, event.dateTime);
    });
  }
}
