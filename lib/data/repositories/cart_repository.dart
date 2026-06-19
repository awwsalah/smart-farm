import 'package:app/data/db/app_database.dart';
import 'package:app/models/product.dart';
import 'package:sqflite/sqflite.dart';

class CartLineItem {
  const CartLineItem({
    required this.cartItemId,
    required this.product,
    required this.quantity,
  });

  final int cartItemId;
  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;
}

class CartRepository {
  CartRepository({Database? db}) : _dbFuture = db != null
      ? Future.value(db)
      : AppDatabase.instance.database;

  final Future<Database> _dbFuture;

  Future<List<CartLineItem>> getItems() async {
    final db = await _dbFuture;
    final rows = await db.rawQuery('''
      SELECT
        cart_items.id AS cart_item_id,
        cart_items.quantity AS quantity,
        products.id AS id,
        products.name AS name,
        products.category AS category,
        products.price AS price,
        products.currency AS currency,
        products.description AS description,
        products.image_asset AS image_asset,
        products.in_stock AS in_stock
      FROM cart_items
      INNER JOIN products ON products.id = cart_items.product_id
      ORDER BY cart_items.id ASC
    ''');

    return rows.map((row) {
      return CartLineItem(
        cartItemId: row['cart_item_id'] as int,
        quantity: row['quantity'] as int,
        product: Product.fromMap({
          'id': row['id'],
          'name': row['name'],
          'category': row['category'],
          'price': row['price'],
          'currency': row['currency'],
          'description': row['description'],
          'image_asset': row['image_asset'],
          'in_stock': row['in_stock'],
        }),
      );
    }).toList();
  }

  Future<int> getItemCount() async {
    final db = await _dbFuture;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(quantity), 0) AS total FROM cart_items',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getTotal() async {
    final items = await getItems();
    return items.fold<double>(0, (sum, item) => sum + item.lineTotal);
  }

  Future<void> addProduct(int productId, {int quantity = 1}) async {
    final db = await _dbFuture;
    final existing = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert('cart_items', {
        'product_id': productId,
        'quantity': quantity,
      });
      return;
    }

    final currentQty = existing.first['quantity'] as int;
    await db.update(
      'cart_items',
      {'quantity': currentQty + quantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> updateQuantity(int cartItemId, int quantity) async {
    final db = await _dbFuture;
    if (quantity <= 0) {
      await db.delete(
        'cart_items',
        where: 'id = ?',
        whereArgs: [cartItemId],
      );
      return;
    }

    await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> removeItem(int cartItemId) async {
    final db = await _dbFuture;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [cartItemId],
    );
  }

  Future<void> clear() async {
    final db = await _dbFuture;
    await db.delete('cart_items');
  }
}