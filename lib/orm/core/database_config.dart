import 'package:sqflite_sqlcipher/sqflite.dart';
import '../schema/table_schema.dart';

class DatabaseConfig {
  final String dbName;
  final int version;
  final String? password;
  final List<TableSchema> tables;
  final bool enableTimestamps;
  final Future<void> Function(Database db, int oldVersion, int newVersion)? onUpgrade;

  const DatabaseConfig({
    required this.dbName,
    this.version = 1,
    this.password,
    this.tables = const [],
    this.enableTimestamps = false,
    this.onUpgrade,
  });
}
