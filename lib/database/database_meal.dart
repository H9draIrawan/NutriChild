import 'package:sqflite/sqflite.dart';

import '../data/model/Meal.dart';

class DatabaseMeal {
  static Database? _database;
  static const String _mealTable = 'meal';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/meal.db",
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE $_mealTable(id TEXT PRIMARY KEY, childId TEXT, mealTime TEXT, date DATE, qty INTEGER)");
      print("DB Created");
    });
    return db;
  }

  Future insertMeal(Meal meal) async {
    final Database db = await database;
    try {
      await db.insert(_mealTable, meal.toMap());
      print("Data Inserted");
    } catch (_) {
      print("Failed to Inserted Data");
    }
  }

  Future<List<Meal>> getMeal() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_mealTable);
    List<Meal> meal = [];
    for (var result in results) {
      meal.add(Meal.fromMap(result));
    }
    print("Database : ${meal.length}");
    return meal;
  }

  Future updateMeal(Meal meal) async {
    final Database db = await database;
    try {
      await db.update(_mealTable, meal.toMap(),
          where: 'mid = ?', whereArgs: [meal.id]);
      print("Data Updated");
    } catch (_) {
      print("Failed to Update Data");
    }
  }

  Future deleteMeal(String mid) async {
    final Database db = await database;
    try {
      await db.delete(_mealTable, where: 'mid = ?', whereArgs: [mid]);
      print("Data Deleted");
    } catch (_) {
      print("Failed to Delete Data");
    }
  }
}
