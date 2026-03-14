import 'package:sqflite_sqlcipher/sqflite.dart';
import 'field.dart';
import 'foreign_key.dart';

class TableSchema {
  final String tableName;
  final List<Field> fields;
  final List<ForeignKey> foreignKeys;
  final List<List<String>> uniqueTogether;

  TableSchema({
    required this.tableName,
    required this.fields,
    this.foreignKeys = const [],
    dynamic uniqueTogether = const [],
  }) : uniqueTogether = _normalizeUniqueTogether(uniqueTogether);

  static List<List<String>> _normalizeUniqueTogether(dynamic input) {
    if (input is List<String>) {
      return [input];
    } else if (input is List<List<String>>) {
      return input;
    }
    return const [];
  }

  /// Validates the schema
  void validate() {
    final pkCount = fields.where((f) => f.isPrimaryKey).length;
    if (pkCount > 1) {
      throw Exception('Table "$tableName" has $pkCount Primary Keys. Composite Primary Keys are not yet supported for automated DML.');
    }
  }

  /// Generate CREATE TABLE statement
  String createTableSql() {
    validate();
    
    final definitions = fields.map((f) => f.toSql()).toList();
    
    for (final fk in foreignKeys) {
      definitions.add(fk.toSql());
    }

    for (final unique in uniqueTogether) {
      definitions.add('UNIQUE (${unique.join(', ')})');
    }

    final allDefinitions = definitions.join(', ');
    return 'CREATE TABLE IF NOT EXISTS $tableName ($allDefinitions)';
  }

  // --- Migration Methods (Returning SQL) ---

  String addColumnSql(String columnName, Field field) {
    return 'ALTER TABLE $tableName ADD COLUMN ${field.toSql()}';
  }

  String dropColumnSql(String columnName) {
    return 'ALTER TABLE $tableName DROP COLUMN $columnName';
  }

  String renameTableSql(String newName) {
    return 'ALTER TABLE $tableName RENAME TO $newName';
  }

  String dropTableSql() {
    return 'DROP TABLE IF EXISTS $tableName';
  }

  // --- Migration Methods (Executing directly) ---
  
  Future<void> addColumn(DatabaseExecutor db, String columnName, Field field) async {
    await db.execute(addColumnSql(columnName, field));
  }

  Future<void> deleteColumn(DatabaseExecutor db, String columnName) async {
    await db.execute(dropColumnSql(columnName));
  }

  Future<void> alterColumn(DatabaseExecutor db, String columnName, Field field) async {
    // SQLite doesn't have a direct ALTER COLUMN. 
    // This is complex in SQLite (requires temp table).
    // For now, we'll just execute the Field SQL and hope for the best if it's a simple type change,
    // though usually this would fail in SQLite.
    // A more complete ORM would handle this via a migration visitor.
    print('ORM Warning: alterColumn is limited in SQLite.');
  }

  Future<void> deleteTable(DatabaseExecutor db) async {
    await db.execute(dropTableSql());
  }

  // --- Helper to add timestamps ---
  void addTimestamps({bool softDelete = false}) {
    if (!fields.any((f) => f.name == 'created_at')) {
      fields.add(Field.text('created_at', isNullable: false));
    }
    if (!fields.any((f) => f.name == 'updated_at')) {
      fields.add(Field.text('updated_at', isNullable: false));
    }
    if (softDelete && !fields.any((f) => f.name == 'deleted_at')) {
      fields.add(Field.text('deleted_at', isNullable: true));
    }
  }
}
