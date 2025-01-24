import 'package:sqflite/sqflite.dart';

import '../model/Meal.dart';

class MealSqflite {
  static Database? _database;
  static const String _mealTable = 'meals';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/meals.db", version: 6,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_mealTable(
          id TEXT PRIMARY KEY,
          childId TEXT NOT NULL,
          foodId TEXT NOT NULL,
          mealTime TEXT NOT NULL,
          dateTime TEXT NOT NULL,
          qty INTEGER NOT NULL,
          FOREIGN KEY (childId) REFERENCES children (id),
          FOREIGN KEY (foodId) REFERENCES foods (id))''');
      print("Meal DB Created");
    });
    return db;
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert(_mealTable, meal.toMap());
  }

  Future<List<Meal>> getMealsByChildId(String childId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _mealTable,
      where: 'childId = ?',
      whereArgs: [childId],
    );
    return List.generate(maps.length, (i) {
      return Meal.fromMap(maps[i]);
    });
  }

  Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete(
      _mealTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteMealbyChildId(String childId) async {
    final db = await database;
    await db.delete(
      _mealTable,
      where: 'childId = ?',
      whereArgs: [childId],
    );
  }

  Future<List<Meal>> getMealsByDate(String childId, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _mealTable,
      where: 'childId = ? AND dateTime = ?',
      whereArgs: [childId, date],
    );
    return List.generate(maps.length, (i) {
      return Meal.fromMap(maps[i]);
    });
  }

  Future<void> deleteMealsByDate(String childId, String date) async {
    final db = await database;
    await db.delete(
      _mealTable,
      where: 'childId = ? AND dateTime = ?',
      whereArgs: [childId, date],
    );
  }
}
