import 'package:sqflite/sqflite.dart';

import '../data/model/Meal.dart';

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
    var db = openDatabase("$path/meal.db", version: 6,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_mealTable(
          id TEXT PRIMARY KEY,
          child_id TEXT NOT NULL,
          food_id TEXT NOT NULL,
          meal_time TEXT NOT NULL,
          date_time TEXT NOT NULL,
          qty INTEGER NOT NULL,
          FOREIGN KEY (child_id) REFERENCES children (id),
          FOREIGN KEY (food_id) REFERENCES foods (id))''');
      print("Meal DB Created");
    });
    return db;
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert(_mealTable, meal.toMap());
  }

  Future<List<Meal>> getMealsByDate(String childId, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _mealTable,
      where: 'child_id = ? AND date(date_time) = ?',
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
      where: 'child_id = ? AND date(date_time) = ?',
      whereArgs: [childId, date],
    );
  }
}
