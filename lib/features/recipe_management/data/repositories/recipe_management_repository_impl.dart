import '../../domain/repositories/recipe_management_repository.dart';

class RecipeManagementRepositoryImpl implements RecipeManagementRepository {
  const RecipeManagementRepositoryImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
