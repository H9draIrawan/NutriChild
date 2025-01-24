import 'child_management_remote_data_source.dart';

class ChildManagementRemoteDataSourceImpl
    implements ChildManagementRemoteDataSource {
  const ChildManagementRemoteDataSourceImpl();

  Future<T> _run<T>(Future<T> Function() function) async {
    try {
      return await function();
    } catch (e) {
      throw e;
    }
  }
}
