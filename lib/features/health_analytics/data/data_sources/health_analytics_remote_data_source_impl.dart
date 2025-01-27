import 'health_analytics_remote_data_source.dart';

class HealthAnalyticsRemoteDataSourceImpl
    implements HealthAnalyticsRemoteDataSource {
  const HealthAnalyticsRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
