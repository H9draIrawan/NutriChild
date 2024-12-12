import 'package:sqflite/sqflite.dart';

import '../data/model/Nutrition.dart';

class DatabaseNutrition {
  static Database? _database;
  static const String _nutritionTable = 'nutrition';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/nutrition.db",
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $_nutritionTable(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, calories DOUBLE, protein DOUBLE, fat DOUBLE, carbohydrates DOUBLE)");
      print("DB Created");
    });
    return db;
  }

  Future insertNutrition(Nutrition nutrition) async {
    final Database db = await database;
    try {
      await db.insert(_nutritionTable, nutrition.toMap());
      print("Data Inserted");
    } catch (_) {
      print("Failed to Inserted Data");
    }
  }

  Future<List<Nutrition>> getNutrition() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_nutritionTable);
    List<Nutrition> nutrition = [];
    for (var result in results) {
      nutrition.add(Nutrition.fromMap(result));
    }
    print("Database : ${nutrition.length}");
    return nutrition;
  }
}
