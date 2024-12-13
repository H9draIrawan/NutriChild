import 'package:sqflite/sqflite.dart';

import '../data/model/Food.dart';

class DatabaseFood {
  static Database? _database;
  static const String _foodTable = 'food';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/food.db",
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $_foodTable(id TEXT PRIMARY KEY AUTOINCREMENT, name TEXT, calories DOUBLE, protein DOUBLE, fat DOUBLE, carbohydrates DOUBLE)");
      print("DB Created");
    });
    return db;
  }

  Future insertFood(Food nutrition) async {
    final Database db = await database;
    try {
      await db.insert(_foodTable, nutrition.toMap());
      print("Data Inserted");
    } catch (_) {
      print("Failed to Inserted Data");
    }
  }

  Future<List<Food>> getFood() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_foodTable);
    List<Food> nutrition = [];
    for (var result in results) {
      nutrition.add(Food.fromMap(result));
    }
    print("Database : ${nutrition.length}");
    return nutrition;
  }
}
