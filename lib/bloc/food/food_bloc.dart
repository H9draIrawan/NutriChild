import 'package:bloc/bloc.dart';
import 'package:nutrichild/bloc/food/food_event.dart';
import 'package:nutrichild/bloc/food/food_state.dart';

import '../../data/model/Food.dart';
import '../../data/model/Meal.dart';
import '../../database/database_food.dart';
import '../../database/database_meal.dart';

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

    on<BreakfastEvent>((event, emit) async {
      final foodId = "F${DateTime.now().toString()}";
      final mealId = "M${DateTime.now().toString()}";

      await foodSqflite.insertFood(Food(
        id: foodId,
        name: event.foodName,
        calories: event.calories,
        imageUrl: event.imageUrl,
      ));

      await mealSqflite.insertMeal(
        Meal(
          id: mealId,
          childId: event.childId,
          foodId: foodId,
          mealTime: 'Breakfast',
          dateTime:
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          qty: event.qty,
        ),
      );

      print("Data Inserted");
    });

    on<LunchEvent>((event, emit) {
      final foodId = "F${DateTime.now().toString()}";
      final mealId = "M${DateTime.now().toString()}";

      foodSqflite.insertFood(Food(
        id: foodId,
        name: event.foodName,
        calories: event.calories,
        imageUrl: event.imageUrl,
      ));

      mealSqflite.insertMeal(
        Meal(
          id: mealId,
          childId: event.childId,
          foodId: foodId,
          mealTime: 'Lunch',
          dateTime:
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          qty: event.qty,
        ),
      );
    });

    on<DinnerEvent>((event, emit) {
      final foodId = "F${DateTime.now().toString()}";
      final mealId = "M${DateTime.now().toString()}";

      foodSqflite.insertFood(Food(
        id: foodId,
        name: event.foodName,
        calories: event.calories,
        imageUrl: event.imageUrl,
      ));

      mealSqflite.insertMeal(
        Meal(
          id: mealId,
          childId: event.childId,
          foodId: foodId,
          mealTime: 'Dinner',
          dateTime:
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
          qty: event.qty,
        ),
      );
    });
  }
}
