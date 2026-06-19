import 'package:app/data/db/app_database.dart';
import 'package:app/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  ProductRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  Future<List<Product>> getAll() async {
    final db = await _dbFuture;
    final rows = await db.query('products', orderBy: 'name ASC');
    return rows.map(Product.fromMap).toList();
  }

  Future<List<Product>> getByCategory(String category) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return rows.map(Product.fromMap).toList();
  }

  Future<Product?> getById(int id) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Product.fromMap(rows.first);
  }

  Future<List<Product>> getPopular({int limit = 6}) async {
    final db = await _dbFuture;
    final rows = await db.query(
      'products',
      where: 'in_stock = ?',
      whereArgs: [1],
      orderBy: 'id ASC',
      limit: limit,
    );
    return rows.map(Product.fromMap).toList();
  }
}