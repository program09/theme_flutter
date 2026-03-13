import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import '../models/model.dart';
import 'database_config.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  Database? _database;
  DatabaseConfig? _config;
  List<Model>? _models;

  Future<void> initialize(DatabaseConfig config, List<Model> models) async {
    _config = config;
    _models = models;
    await database; // force init
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    if (_config == null) throw Exception('DatabaseManager must be initialized first');
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _config!.dbName);

    return await openDatabase(
      path,
      password: _config!.password,
      version: _config!.version,
      onCreate: (db, version) async {
        if (_models != null) {
          for (final model in _models!) {
            await db.execute(model.tableSchema.createTableSql());
          }
        }
      },
      onUpgrade: _config!.onUpgrade,
    );
  }
}
