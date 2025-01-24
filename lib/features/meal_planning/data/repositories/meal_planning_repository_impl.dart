import '../../domain/repositories/meal_planning_repository.dart';

class MealPlanningRepositoryImpl implements MealPlanningRepository {
  const MealPlanningRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
