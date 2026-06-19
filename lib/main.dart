import 'package:app/app.dart';
import 'package:app/data/db/app_database.dart';
import 'package:app/data/db/seeder.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await AppDatabase.instance.database;
  await Seeder(db).seedIfNeeded();

  runApp(const BeeralayApp());
}