import 'package:sqflite/sqflite.dart';

import '../model/Allergy.dart';

class AllergySqflite {
  static Database? _database;
  static const String _allergyTable = 'allergies';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/allergies.db", version: 4,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_allergyTable (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT NOT NULL
          )''');
      print("DB Created");

      final List<Allergy> allergies = [
        Allergy(
          id: 'A001',
          name: 'Egg',
          description: 'Common food allergy that causes reactions to egg proteins found in both egg whites and yolks. Avoid eggs and products containing eggs like mayonnaise, some baked goods, and certain sauces.'
        ),
        Allergy(
          id: 'A002',
          name: 'Milk',
          description: 'Allergic reaction to proteins in cow\'s milk and dairy products. Includes milk, cheese, yogurt, butter, cream, and products containing milk proteins (casein and whey).'
        ),
        Allergy(
          id: 'A003',
          name: 'Peanut',
          description: 'Severe allergy that can cause serious reactions. Avoid peanuts, peanut butter, peanut oil, and foods that may contain traces of peanuts. Often requires strict avoidance due to cross-contamination risks.'
        ),
        Allergy(
          id: 'A004',
          name: 'Soybean',
          description: 'Reaction to soy proteins found in soybeans and soy products. Common in foods like tofu, soy sauce, edamame, and many processed foods containing soy lecithin or soy protein.'
        ),
        Allergy(
          id: 'A005',
          name: 'Fish',
          description: 'Allergic reaction to proteins in fish. Affects various types of fish including salmon, tuna, and cod. Can be severe and usually requires avoiding all fish products and watching for cross-contamination.'
        ),
        Allergy(
          id: 'A006',
          name: 'Wheat',
          description: 'Allergy to proteins found in wheat and wheat products. Different from celiac disease. Avoid wheat flour, bread, pasta, and many processed foods containing wheat derivatives.'
        ),
        Allergy(
          id: 'A007',
          name: 'Celery',
          description: 'Allergy to celery and celery roots (celeriac). Can affect both raw and cooked forms. Found in many soups, broths, and seasonings. May cause severe reactions in sensitive individuals.'
        ),
        Allergy(
          id: 'A008',
          name: 'Crustacean',
          description: 'Severe allergy to shellfish like shrimp, crab, and lobster. One of the most common food allergies in adults. Can cause serious reactions even to small amounts or vapors from cooking.'
        ),
        Allergy(
          id: 'A009',
          name: 'Mustard',
          description: 'Allergy to mustard seeds and mustard-based products. Found in various condiments, sauces, marinades, and processed foods. Can cause reactions ranging from mild to severe.'
        ),
      ];
      for (var allergy in allergies) {
        await db.insert(_allergyTable, allergy.toMap());
      }
    });
    return db;
  }

  Future<void> insertAllergy(Allergy allergy) async {
    final Database db = await database;
    await db.insert(_allergyTable, allergy.toMap());
  }

  Future<String> getAllergybyName(String name) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(_allergyTable, where: 'name = ?', whereArgs: [name]);
    if (maps.isNotEmpty) {
      return maps[0]['id'];
    }
    return "";
  }
}
