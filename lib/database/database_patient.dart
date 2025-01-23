import 'package:sqflite/sqflite.dart';

import '../model/patient.dart';

class PatientSqflite {
  static Database? _database;
  static const String _patientTable = 'patients';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase("$path/patients.db", version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_patientTable(
          id TEXT PRIMARY KEY,
          childId TEXT NOT NULL,
          allergyId TEXT NOT NULL,
          FOREIGN KEY (childId) REFERENCES children (id),
          FOREIGN KEY (allergyId) REFERENCES allergies (id))
          ''');
      print("DB Created");
    });
    return db;
  }

  Future<void> insertPatient(Patient patient) async {
    final Database db = await database;
    await db.insert(_patientTable, patient.toMap());
  }

  Future<void> deletePatient(String id) async {
    final Database db = await database;
      await db.delete(_patientTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deletePatientByChildId(String childId) async {
    final Database db = await database;
    await db.delete(_patientTable, where: 'childId = ?', whereArgs: [childId]);
  }

  Future<void> updatePatient(Patient patient) async {
    final Database db = await database;
    await db.update(_patientTable, patient.toMap(), where: 'id = ?', whereArgs: [patient.id]);
  }

  Future<List<Patient>> getPatientByChildId(String childId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_patientTable, where: 'childId = ?', whereArgs: [childId]);
    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }
}
