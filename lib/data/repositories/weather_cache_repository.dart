import 'package:app/data/db/app_database.dart';
import 'package:app/models/weather.dart';
import 'package:sqflite/sqflite.dart';

class WeatherCacheRepository {
  WeatherCacheRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  Future<WeatherData?> getCached() async {
    final db = await _dbFuture;
    final rows = await db.query(
      'weather_cache',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return WeatherData.fromMap(rows.first);
  }

  Future<void> save(WeatherData data) async {
    final db = await _dbFuture;
    await db.insert(
      'weather_cache',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}