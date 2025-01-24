import 'meal_planning_remote_data_source.dart';

class MealPlanningRemoteDataSourceImpl implements MealPlanningRemoteDataSource {
  const MealPlanningRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
