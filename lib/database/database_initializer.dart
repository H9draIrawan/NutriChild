import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DatabaseInitializer {
  static bool _initialized = false;

  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<void> initialize() async {
    if (_initialized) {
      print("Database already initialized");
      return;
    }

    try {
      print("Current platform status:");
      print("- Is Web: $kIsWeb");

      if (kIsWeb) {
        print("Web platform detected - SQLite initialization skipped");
        return;
      }

      print("- Is Windows: ${Platform.isWindows}");
      print("- Is Linux: ${Platform.isLinux}");
      print("- Is macOS: ${Platform.isMacOS}");
      print("- Is Android: ${Platform.isAndroid}");
      print("- Is iOS: ${Platform.isIOS}");

      if (isDesktop) {
        print("Initializing SQLite for desktop platform...");
        // Initialize FFI
        sqfliteFfiInit();
        // Set the factory BEFORE any database operations
        databaseFactory = databaseFactoryFfi;
        print("FFI SQLite initialization completed");
      } else if (isMobile) {
        print("Mobile platform detected - using default SQLite implementation");
      } else {
        throw UnsupportedError("Unsupported platform for SQLite");
      }

      // Verify initialization
      print("Verifying database initialization...");
      final path = await getDatabasesPath();
      print("Database path obtained: $path");

      _initialized = true;
      print("Database initialization verified successfully");
    } catch (e, stackTrace) {
      print("Failed to initialize database: $e");
      print("Stack trace: $stackTrace");
      _initialized = false;
      rethrow;
    }
  }

  static bool isInitialized() {
    return _initialized;
  }

  static Future<void> ensureInitialized() async {
    if (!_initialized && !kIsWeb) {
      await initialize();
    }
  }

  static Future<void> testConnection() async {
    if (kIsWeb) {
      print("Skipping database test on web platform");
      return;
    }

    await ensureInitialized();

    Database? testDb;
    try {
      final path = await getDatabasesPath();
      print("Opening test database at: $path");

      testDb = await openDatabase(
        '$path/test.db',
        version: 1,
        onCreate: (db, version) async {
          print("Creating test table...");
          await db.execute(
              'CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY)');
        },
      );

      print("Testing database operations...");
      await testDb.insert('test', {'id': 1});
      final result = await testDb.query('test');
      print("Test query result: $result");

      print("Database test completed successfully");
    } catch (e, stackTrace) {
      print("Database test failed: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    } finally {
      if (testDb != null) {
        await testDb.close();
        print("Test database closed");
      }
    }
  }
}
