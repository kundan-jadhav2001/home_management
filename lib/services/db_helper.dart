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
      version: 1,
    );
  }

  static Future<void> _createDb(Database database, int version) async {
    await database.execute("""
        "CREATE TABLE bills("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "name TEXT, dueDate TEXT, "
        "amount REAL, "
        "status TEXT)"""
    );

      await database.execute(
          "CREATE TABLE users("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "username TEXT, "
          "password TEXT, "
          "email TEXT)"
    );
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
      );
    });
  }

  static Future<void> updateBill(Bill bill) async {
    final db = await initializeDB();

    await db.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }

  static Future<void> deleteBill(int id) async {
    final db = await initializeDB();
    await db.delete('bills', where: "id = ?", whereArgs: [id]);
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