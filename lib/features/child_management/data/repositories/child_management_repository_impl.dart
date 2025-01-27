import '../../domain/repositories/child_management_repository.dart';

class ChildManagementRepositoryImpl implements ChildManagementRepository {
  const ChildManagementRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      rethrow;
    }
  }
}
