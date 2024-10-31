import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ativ_user.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              carne TEXT NOT NULL,
              slider INTEGER NOT NULL,
              data TEXT NOT NULL,
              hora TEXT NOT NULL,
              ponto TEXT)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertUser(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  Future<List<User>> getAllUsers() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        carne: maps[i]['carne'],
        slider: maps[i]['slider'],
        data: maps[i]['data'],
        hora: maps[i]['hora'],
        ponto: maps[i]['ponto'],
      );
    });
  }

  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<void> deleteUser(int? id) async {
    if (id == null) return;

    final db = await initializeDB();
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateSliderValue(int sliderValue) async {
    final db = await initializeDB();

    final List<Map<String, dynamic>> lastOrder = await db.query(
      'users',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (lastOrder.isNotEmpty) {
      return await db.update(
        'users',
        {'slider': sliderValue},
        where: 'id = ?',
        whereArgs: [lastOrder.first['id']],
      );
    }
    return 0;
  }

  Future<int> updateUser(User user) async {
    final db = await initializeDB();
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
