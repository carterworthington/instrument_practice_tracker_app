import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';

class LogSessionDbManager {
  // Private constructor for a singleton
  const LogSessionDbManager._();

  // Singleton instance
  static const LogSessionDbManager instance = LogSessionDbManager._();

  static const _dbName = 'log_sessions.db';
  static const _dbVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _connectToDB();
    return _database!;
  }

  Future<Database> _connectToDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE log_session(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            instrument TEXT NOT NULL,
            durationSeconds INTEGER NOT NULL,
            notes TEXT NOT NULL,
            audioPath TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertSession(LogSession session) async {
    final db = await database;

    await db.insert(
      'log_session',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LogSession>> getSessions() async {
    final db = await database;
    final rows = await db.query('log_session');

    return [for (final map in rows) LogSession.fromMap(map)];
  }

  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete('log_session', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDB() async {
    final db = await database;
    await db.close();
  }
}
