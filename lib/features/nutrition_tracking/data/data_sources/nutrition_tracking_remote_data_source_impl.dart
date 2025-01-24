import 'nutrition_tracking_remote_data_source.dart';

class NutritionTrackingRemoteDataSourceImpl
    implements NutritionTrackingRemoteDataSource {
  const NutritionTrackingRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
