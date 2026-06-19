import 'package:app/data/db/app_database.dart';
import 'package:app/models/news_item.dart';
import 'package:sqflite/sqflite.dart';

class NewsRepository {
  NewsRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  /// v1: returns local SQLite rows (seeded from assets/data/news.json).
  ///
  /// FUTURE HOOK — swap the body below for a live source when ready:
  ///   - HTTP call to a news API, or
  ///   - Firebase / remote DB read,
  /// then upsert rows into `news` and return them. UI stays unchanged.
  Future<List<NewsItem>> fetchNews() async {
    final db = await _dbFuture;
    final rows = await db.query('news', orderBy: 'published_at DESC');
    return rows.map(NewsItem.fromMap).toList();
  }

  Future<NewsItem?> getById(int id) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'news',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return NewsItem.fromMap(rows.first);
  }
}