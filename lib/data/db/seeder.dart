import 'dart:convert';

import 'package:app/models/article.dart';
import 'package:app/models/news_item.dart';
import 'package:app/models/product.dart';
import 'package:app/models/tip.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class Seeder {
  Seeder(this._db);

  final Database _db;

  Future<void> seedIfNeeded() async {
    final result = await _db.rawQuery('SELECT COUNT(*) AS c FROM products');
    final count = Sqflite.firstIntValue(result) ?? 0;
    if (count > 0) return;

    await _seedProducts();
    await _seedArticles();
    await _seedNews();
    await _seedTips();
  }

  Future<void> _seedProducts() async {
    final jsonStr = await rootBundle.loadString('assets/data/products.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    final batch = _db.batch();

    for (final item in list) {
      final product = Product.fromJson(item as Map<String, dynamic>);
      batch.insert('products', product.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> _seedArticles() async {
    final jsonStr = await rootBundle.loadString('assets/data/articles.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    final batch = _db.batch();

    for (final item in list) {
      final article = Article.fromJson(item as Map<String, dynamic>);
      batch.insert('articles', article.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> _seedNews() async {
    final jsonStr = await rootBundle.loadString('assets/data/news.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    final batch = _db.batch();

    for (final item in list) {
      final news = NewsItem.fromJson(item as Map<String, dynamic>);
      batch.insert('news', news.toMap());
    }

    await batch.commit(noResult: true);
  }

  Future<void> _seedTips() async {
    final jsonStr = await rootBundle.loadString('assets/data/tips.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    final batch = _db.batch();

    for (final item in list) {
      final tip = Tip.fromJson(item as Map<String, dynamic>);
      batch.insert('tips', tip.toMap());
    }

    await batch.commit(noResult: true);
  }
}