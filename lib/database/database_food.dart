import 'package:sqflite/sqflite.dart';

import '../data/model/Food.dart';

class FoodSqflite {
  static Database? _database;
  static const String _foodTable = 'food';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/food.db",
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_foodTable(
          id TEXT PRIMARY KEY,
          name TEXT,
          calories DOUBLE,
          imageUrl TEXT,
          )
          ''');
      print("DB Created");
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
}
