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
    this.uniqueTogether = const [],
  });

  /// Validates and ensures fields contain exactly 1 primary key 
  void validate() {
    final pkCount = fields.where((f) => f.isPrimaryKey).length;
    if (pkCount != 1) {
      throw Exception('Table "$tableName" must have exactly one Primary Key, found $pkCount.');
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
}
