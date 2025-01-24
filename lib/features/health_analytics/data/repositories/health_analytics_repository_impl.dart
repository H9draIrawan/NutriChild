import '../../domain/repositories/health_analytics_repository.dart';

class HealthAnalyticsRepositoryImpl implements HealthAnalyticsRepository {
  const HealthAnalyticsRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
