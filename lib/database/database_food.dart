import 'package:sqflite/sqflite.dart';

import '../model/Food.dart';

class FoodSqflite {
  static Database? _database;
  static const String _foodTable = 'foods';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/foods.db", version: 6,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_foodTable(
          id TEXT PRIMARY KEY, 
          name TEXT NOT NULL,
          calories REAL NOT NULL,
          protein REAL,
          carbs REAL,
          fat REAL,
          imageUrl TEXT)''');
      print("Food DB Created");
    });
    return db;
  }

  Future<void> insertFood(Food food) async {
    final db = await database;
    await db.insert(_foodTable, food.toMap());
  }

  Future<void> updateFood(Food food) async {
    final db = await database;
    await db.update(
      _foodTable,
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  Future<List<Food>> getFood() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_foodTable);
    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<List<Food>> getFoodbyId(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _foodTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<List<Food>> getFoodByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _foodTable,
      where: 'name = ?',
      whereArgs: [name],
    );
    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<void> deleteFood(String id) async {
    final db = await database;
    await db.delete(
      _foodTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFoodByName(String name) async {
    final db = await database;
    await db.delete(
      _foodTable,
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> deleteFoodById(String id) async {
    final db = await database;
    await db.delete(
      _foodTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFoodByDate(String date) async {
    final db = await database;
    await db.delete(
      _foodTable,
      where: 'date = ?',
      whereArgs: [date],
    );
  }
}
