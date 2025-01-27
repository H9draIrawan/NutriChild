import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/child.dart';
import 'database_child.dart';

abstract class DatabaseInterface {
  Future<List<Child>> getChildByUserId(String userId);
  // Add other methods as needed
}

class WebDatabaseImpl implements DatabaseInterface {
  @override
  Future<List<Child>> getChildByUserId(String userId) async {
    // For web platform, return empty list or handle differently
    print("Web platform: Database operations not supported");
    return [];
  }
}

class NativeDatabaseImpl implements DatabaseInterface {
  final _childDb = ChildSqflite();

  @override
  Future<List<Child>> getChildByUserId(String userId) {
    return _childDb.getChildByUserId(userId);
  }
}

class DatabaseFactory {
  static DatabaseInterface getDatabase() {
    if (kIsWeb) {
      print("Creating web database implementation");
      return WebDatabaseImpl();
    } else {
      print("Creating native database implementation");
      return NativeDatabaseImpl();
    }
  }
}
