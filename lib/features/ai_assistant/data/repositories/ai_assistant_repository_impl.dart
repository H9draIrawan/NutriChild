import '../../domain/repositories/ai_assistant_repository.dart';

class AIAssistantRepositoryImpl implements AIAssistantRepository {
  const AIAssistantRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
