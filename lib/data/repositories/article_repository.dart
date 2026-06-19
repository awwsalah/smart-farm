import 'package:app/data/db/app_database.dart';
import 'package:app/models/article.dart';
import 'package:sqflite/sqflite.dart';

class ArticleRepository {
  ArticleRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  Future<List<Article>> getAll() async {
    final db = await _dbFuture;
    final rows = await db.query('articles', orderBy: 'created_at DESC');
    return rows.map(Article.fromMap).toList();
  }

  Future<List<Article>> getByCategory(String category) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'articles',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return rows.map(Article.fromMap).toList();
  }

  Future<Article?> getById(int id) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Article.fromMap(rows.first);
  }
}