import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:home_management/models/bill.dart';
import 'dart:async';
import 'package:home_management/models/user.dart';
class DBHelper {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'home_management.db'),
      onCreate: (database, version) async {
        await _createDb(database, version);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if(oldVersion < newVersion){
          await _upgradeDb(db, oldVersion, newVersion);
        }
      },
      version: 2,
    );
  }

  static Future<void> _createDb(Database database, int version) async {
    await database.execute(
        "CREATE TABLE bills("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "reminder INTEGER,"
        "name TEXT, dueDate TEXT, type TEXT, "
        "amount REAL, status TEXT)");

      await database.execute(
          "CREATE TABLE users("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "username TEXT,"
          "password TEXT,"
          "email TEXT)"
    );
  }

  static Future<void> _upgradeDb(Database database, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await database.execute("ALTER TABLE bills ADD COLUMN reminder INTEGER");
    }

  }
  static Future<int> insertBill(Bill bill) async {
    final Database db = await initializeDB();
    return await db.insert(

      'bills',
      bill.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Bill>> getBills() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('bills');

    return List.generate(maps.length, (i) {
      return Bill(
        id: maps[i]['id'],
        name: maps[i]['name'],
        dueDate: DateTime.parse(maps[i]['dueDate']),
        amount: maps[i]['amount'],
        status: maps[i]['status'],
        type: maps[i]['type'],
        reminder : maps[i]['reminder']
      );
    });
  }
  static Future<List<Bill>> getBillsByType(String type) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('bills', where: 'type = ?', whereArgs: [type]);

    return List.generate(maps.length, (i) {
      return Bill(
        id: maps[i]['id'],
        name: maps[i]['name'],
        dueDate: DateTime.parse(maps[i]['dueDate']),
        amount: maps[i]['amount'],
        status: maps[i]['status'],
        type: maps[i]['type'],
        reminder : maps[i]['reminder']
      );
    });
  }

  static Future<void> updateBill({
  required int id,
  required String name,
  required DateTime dueDate,
  required double amount,
  required String status,
  required String type,
  required int reminder,
}) async {
  final db = await initializeDB();
  await db.update('bills', {
    'name': name,
    'dueDate': dueDate.toIso8601String(),
    'amount': amount,
    'status': status,
    'type': type,    
    'reminder' : reminder,
  }, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteBill(int id) async {
    final db = await initializeDB();
    await db.delete(
      'bills', where: "id = ?", whereArgs: [id]
    );
  }

  static Future<int> insertUser(User user) async {
    final Database db = await initializeDB();
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<User>> getUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
        email: maps[i]['email'],
      );
    });
  }

  static Future<void> updateUser(User user) async {
    final db = await initializeDB();

    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  static Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}