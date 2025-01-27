import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/child.dart';
import 'database_initializer.dart';

class ChildSqflite {
  static Database? _database;
  static const String _childTable = 'children';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    if (kIsWeb) {
      throw UnsupportedError(
          "SQLite operations are not supported on web platform");
    }

    // Ensure database is initialized
    await DatabaseInitializer.initialize();

    var path = await getDatabasesPath();
    var db = await openDatabase("$path/children.db", version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_childTable(
          id TEXT PRIMARY KEY, userId TEXT, name TEXT, age INTEGER, gender TEXT, weight DOUBLE, height DOUBLE, goal TEXT)
          ''');
      print("DB Created");
    });
    return db;
  }

  Future insertChild(Child child) async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return;
    }
    final Database db = await database;
    try {
      await db.insert(_childTable, child.toMap());
      print("Data Inserted");
    } catch (_) {
      print("Failed to Insert Data");
    }
  }

  Future<List<Child>> getChild() async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return [];
    }
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_childTable);
    List<Child> child = [];
    for (var result in results) {
      child.add(Child.fromMap(result));
    }
    print("Database : ${child.length}");
    return child;
  }

  Future<Child?> getChildById(String id) async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return null;
    }
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_childTable, where: 'id = ?', whereArgs: [id]);
    return Child.fromMap(results.first);
  }

  Future<List<Child>> getChildByUserId(String userId) async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return [];
    }
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_childTable, where: 'userId = ?', whereArgs: [userId]);
    return results.map((result) => Child.fromMap(result)).toList();
  }

  Future updateChild(Child child) async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return;
    }
    final Database db = await database;
    try {
      await db.update(_childTable, child.toMap(),
          where: 'id = ?', whereArgs: [child.id]);
      print("Data Updated");
    } catch (_) {
      print("Failed to Update Data");
    }
  }

  Future deleteChild(String id) async {
    if (kIsWeb) {
      print("Skipping SQLite operation on web platform");
      return;
    }
    final Database db = await database;
    try {
      await db.delete(_childTable, where: 'id = ?', whereArgs: [id]);
      print("Data Deleted");
    } catch (_) {
      print("Failed to Delete Data");
    }
  }
}
