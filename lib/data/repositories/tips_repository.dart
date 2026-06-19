import 'package:app/data/db/app_database.dart';
import 'package:app/models/tip.dart';
import 'package:sqflite/sqflite.dart';

class TipsRepository {
  TipsRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  Future<List<Tip>> getAll() async {
    final db = await _dbFuture;
    final rows = await db.query('tips', orderBy: 'id ASC');
    return rows.map(Tip.fromMap).toList();
  }

  Future<List<Tip>> getLatest({int limit = 6}) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'tips',
      orderBy: 'id DESC',
      limit: limit,
    );
    return rows.map(Tip.fromMap).toList();
  }
}