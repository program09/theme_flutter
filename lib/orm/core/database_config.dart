import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseConfig {
  final String dbName;
  final int version;
  final String? password;
  final Future<void> Function(Database db, int oldVersion, int newVersion)? onUpgrade;

  const DatabaseConfig({
    required this.dbName,
    this.version = 1,
    this.password,
    this.onUpgrade,
  });
}
