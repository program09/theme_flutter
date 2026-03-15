import 'dart:async';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart';
import 'database_config.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  Database? _database;
  DatabaseConfig? _config;
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitializing = false;

  Future<Database> initialize(DatabaseConfig config) async {
    if (_isInitializing) {
      await _initCompleter.future;
      return _database!;
    }

    // If already initialized with same config, do nothing
    if (_database != null && _config == config) return _database!;

    _isInitializing = true;
    _config = config;

    try {
      // If we had a database and it wasn't set externally, close it
      if (_database != null) {
        await _database!.close();
        _database = null;
      }

      // Perform the actual initialization if not already set externally
      if (_database == null) {
        final db = await _initDatabase();
        await _createTables(db);
        _database = db;
      } else {
        // If it was set externally, we still ensure tables exist
        await _createTables(_database!);
      }
      
      if (!_initCompleter.isCompleted) _initCompleter.complete();
      return _database!;
    } catch (e) {
      if (!_initCompleter.isCompleted) _initCompleter.completeError(e);
      _isInitializing = false; // Reset so we can try again
      rethrow;
    } finally {
      // Done initializing
    }
  }

  /// Allows the user to provide an existing database instance
  /// Call this BEFORE initialize()
  void useExternalDatabase(Database db) {
    if (_database != null && _database != db) {
      _database!.close();
    }
    _database = db;
    // Mark as initialized if we are setting an external DB
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete();
    }
  }

  Future<Database> get database async {
    // If already initialized, return it
    if (_database != null) return _database!;

    // If currently initializing, wait for it
    if (_isInitializing) {
      await _initCompleter.future;
      return _database!;
    }

    throw Exception('DatabaseManager must be initialized first');
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _config!.dbName);

    return await openDatabase(
      path,
      password: _config!.password,
      version: _config!.version,
      onConfigure: (db) async {
        // Ensure foreign keys are enforced
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // First run the user-provided upgrade logic if any
        if (_config!.onUpgrade != null) {
          await _config!.onUpgrade!(db, oldVersion, newVersion);
        }
        // Then ensure all current models have their tables
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    if (_config == null) return;

    for (final schema in _config!.tables) {
      if (_config!.enableTimestamps) {
        schema.addTimestamps();
      }
      final sql = schema.createTableSql();
      print('ORM: Ensuring table exists: ${schema.tableName}');
      await db.execute(sql);
    }
  }
}
