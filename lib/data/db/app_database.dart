import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'beeralay.db';
  static const _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final dbPath = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id            INTEGER PRIMARY KEY,
        name          TEXT NOT NULL,
        category      TEXT NOT NULL,
        price         REAL NOT NULL,
        currency      TEXT DEFAULT 'USD',
        description   TEXT,
        image_asset   TEXT,
        in_stock      INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE articles (
        id            INTEGER PRIMARY KEY,
        title         TEXT NOT NULL,
        category      TEXT NOT NULL,
        body          TEXT NOT NULL,
        image_asset   TEXT,
        created_at    TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE news (
        id            INTEGER PRIMARY KEY,
        title         TEXT NOT NULL,
        summary       TEXT,
        source        TEXT,
        image_asset   TEXT,
        published_at  TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tips (
        id            INTEGER PRIMARY KEY,
        text          TEXT NOT NULL,
        category      TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id    INTEGER NOT NULL,
        quantity      INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (product_id) REFERENCES products(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id    INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE weather_cache (
        id            INTEGER PRIMARY KEY CHECK (id = 1),
        region        TEXT,
        temp_c        REAL,
        weather_code  INTEGER,
        fetched_at    TEXT
      )
    ''');
  }
}