import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nutrichild/domain/entities/allergy.dart';
import 'package:nutrichild/data/models/allergy_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AllergyLocalDataSource {
  Future<void> initDatabase();
  Future<List<Allergy>> getAllergybyChildId(String childId);
}

class AllergyLocalDataSourceImpl implements AllergyLocalDataSource {
  Database? _database;
  static const String tableName = 'allergies';

  // Daftar alergi default
  final List<Map<String, dynamic>> _defaultAllergies = [
    {'id': 'allergy_1', 'name': 'egg'},
    {'id': 'allergy_2', 'name': 'milk'},
    {'id': 'allergy_3', 'name': 'peanuts'},
    {'id': 'allergy_4', 'name': 'soybean'},
    {'id': 'allergy_5', 'name': 'fish'},
    {'id': 'allergy_6', 'name': 'wheat'},
    {'id': 'allergy_7', 'name': 'celery'},
    {'id': 'allergy_8', 'name': 'crustacean'},
    {'id': 'allergy_9', 'name': 'mustard'},
  ];

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
  }

  Future<void> _insertDefaultAllergies(Database db) async {
    for (var allergy in _defaultAllergies) {
      await db.insert(tableName, allergy);
    }
  }

  @override
  Future<void> initDatabase() async {
    var path = await getDatabasesPath();
    _database = await databaseFactory.openDatabase(
      '$path/allergies.db',
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await _createTable(db);
          await _insertDefaultAllergies(db);
        },
      ),
    );
  }

  @override
  Future<List<Allergy>> getAllergybyChildId(String id) async {
    final List<Map<String, dynamic>> allergies = await _database?.query(
          tableName,
          where: 'id = ?',
          whereArgs: [id],
        ) ??
        [];
    return allergies.map((e) => AllergyModel.fromJson(e)).toList();
  }
}
