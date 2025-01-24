import 'recipe_management_remote_data_source.dart';

class RecipeManagementRemoteDataSourceImpl
    implements RecipeManagementRemoteDataSource {
  const RecipeManagementRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
