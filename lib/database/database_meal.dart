import 'package:sqflite/sqflite.dart';

import '../data/model/Meal.dart';

class MealSqflite {
  static Database? _database;
  static const String _mealTable = 'meal';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/meal.db", version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_mealTable (
          id TEXT PRIMARY KEY,
          childId TEXT,
          foodId TEXT,
          mealTime TEXT, 
          dateTime TEXT,
          qty INTEGER)''');
      print("DB Created");
    });
    return db;
  }

  Future insertMeal(Meal meal) async {
    final Database db = await database;
    await db.insert(_mealTable, meal.toMap());
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

  Future<List<Meal>> getMealbyChildId(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _mealTable,
      where: 'childId = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Meal.fromMap(maps[i]);
    });
  }
}
