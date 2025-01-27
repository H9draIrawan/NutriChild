import 'ai_assistant_remote_data_source.dart';

class AIAssistantRemoteDataSourceImpl implements AIAssistantRemoteDataSource {
  const AIAssistantRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
