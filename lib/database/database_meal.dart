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
    var db = openDatabase("$path/meal.db", version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_mealTable (
          id TEXT PRIMARY KEY,
          childId TEXT,
          foodId TEXT,
          mealTime TEXT, 
          dateTime TEXT,
          qty INTEGER)''');

      await db.execute('''CREATE TABLE meal_plans (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          meal_type TEXT,
          meal_id TEXT,
          name TEXT,
          calories INTEGER,
          protein REAL,
          carbs REAL,
          fat REAL)''');

      await db.execute('''CREATE TABLE meal_plan_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT
      )''');

      print("DB Created");
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''CREATE TABLE meal_plans (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          meal_type TEXT,
          meal_id TEXT,
          name TEXT,
          calories INTEGER,
          protein REAL,
          carbs REAL,
          fat REAL)''');
      }
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

  Future<void> saveMealPlan({
    required DateTime date,
    List<Meal>? breakfast,
    List<Meal>? lunch,
    List<Meal>? dinner,
  }) async {
    final db = await database;
    final batch = db.batch();

    // Format tanggal ke string YYYY-MM-DD
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // Hapus meal plan yang sudah ada untuk tanggal tersebut
    await db.delete(
      'meal_plans',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    // Insert meal plan baru
    if (breakfast != null) {
      for (var meal in breakfast) {
        batch.insert('meal_plans', {
          'date': dateStr,
          'meal_type': 'breakfast',
          'meal_id': meal.id,
          'name': meal.name,
          'calories': meal.calories,
          'protein': meal.protein,
          'carbs': meal.carbs,
          'fat': meal.fat,
        });
      }
    }

    if (lunch != null) {
      for (var meal in lunch) {
        batch.insert('meal_plans', {
          'date': dateStr,
          'meal_type': 'lunch',
          'meal_id': meal.id,
          'name': meal.name,
          'calories': meal.calories,
          'protein': meal.protein,
          'carbs': meal.carbs,
          'fat': meal.fat,
        });
      }
    }

    if (dinner != null) {
      for (var meal in dinner) {
        batch.insert('meal_plans', {
          'date': dateStr,
          'meal_type': 'dinner',
          'meal_id': meal.id,
          'name': meal.name,
          'calories': meal.calories,
          'protein': meal.protein,
          'carbs': meal.carbs,
          'fat': meal.fat,
        });
      }
    }

    await batch.commit();
  }

  // Method untuk mengambil meal plan berdasarkan tanggal
  Future<Map<String, List<Meal>>> getMealPlan(DateTime date) async {
    final db = await database;
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await db.query(
      'meal_plans',
      where: 'date = ?',
      whereArgs: [dateStr],
    );

    final meals = {
      'breakfast': <Meal>[],
      'lunch': <Meal>[],
      'dinner': <Meal>[],
    };

    for (var map in maps) {
      final meal = Meal(
        id: map['meal_id'] ?? '',
        childId: 'default',
        foodId: map['meal_id'] ?? '',
        mealTime: map['meal_type'] ?? '',
        dateTime: map['date'] ?? '',
        qty: 1,
        name: map['name'] ?? '',
        calories: map['calories'] ?? 0,
        protein: (map['protein'] ?? 0).toDouble(),
        carbs: (map['carbs'] ?? 0).toDouble(),
        fat: (map['fat'] ?? 0).toDouble(),
      );

      meals[map['meal_type']]?.add(meal);
    }

    return meals;
  }

  // Tambahkan fungsi untuk menyimpan deskripsi meal plan
  Future<void> saveMealPlanDescription(String description) async {
    final db = await database;
    await db.insert(
      'meal_plan_description',
      {'description': description},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fungsi untuk mengambil deskripsi
  Future<String> getMealPlanDescription() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('meal_plan_description');
    if (result.isNotEmpty) {
      return result.first['description'] as String;
    }
    return 'No description available';
  }

  Future<void> saveMealPlanInfo({
    required String title,
    required String description,
  }) async {
    final db = await database;
    await db.insert(
      'meal_plan_info',
      {
        'title': title,
        'description': description,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, String>> getMealPlanInfo() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('meal_plan_info');
    if (result.isNotEmpty) {
      return {
        'title': result.first['title'] as String,
        'description': result.first['description'] as String,
      };
    }
    return {
      'title': 'My mealplan',
      'description': 'No description available',
    };
  }
}
