import '../../domain/repositories/nutrition_tracking_repository.dart';

class NutritionTrackingRepositoryImpl implements NutritionTrackingRepository {
  const NutritionTrackingRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
