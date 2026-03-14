import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:ui/orm/core/db_manager.dart';

/// Fluent query builder and basic DML helpers
class QueryBuilder {
  final String tableName;
  final DatabaseExecutor? executor;

  List<String>? _selectColumns;
  String? _whereClause;
  List<dynamic>? _whereArgs;
  String? _orderByClause;
  String? _groupByClause;
  int? _limitValue;
  int? _offsetValue;
  final List<String> _joins = [];

  QueryBuilder(this.tableName, {this.executor});

  Future<DatabaseExecutor> get _db async =>
      executor ?? await DatabaseManager().database;

  /// Select specific columns
  QueryBuilder select(List<String> columns) {
    _selectColumns = columns;
    return this;
  }

  /// Add columns to the current selection
  QueryBuilder addSelect(String sql) {
    _selectColumns ??= [];
    _selectColumns!.add(sql);
    return this;
  }

  /// Add a JOIN clause
  QueryBuilder join(String table, String condition, {String type = 'INNER'}) {
    _joins.add('$type JOIN $table ON $condition');
    return this;
  }

  QueryBuilder innerJoin(String table, String condition) {
    return join(table, condition, type: 'INNER');
  }

  QueryBuilder leftJoin(String table, String condition) {
    return join(table, condition, type: 'LEFT');
  }

  /// Add a WHERE condition
  QueryBuilder where(String column, dynamic value, {String operator = '='}) {
    return andWhere('$column $operator ?', [value]);
  }

  /// Add an AND WHERE condition explicitly
  QueryBuilder andWhere(String where, [List<dynamic> args = const []]) {
    if (_whereClause == null) {
      _whereClause = where;
      _whereArgs = [...args];
    } else {
      _whereClause = '($_whereClause) AND ($where)';
      _whereArgs!.addAll(args);
    }
    return this;
  }

  /// Add an OR WHERE condition
  QueryBuilder orWhere(String where, [List<dynamic> args = const []]) {
    if (_whereClause == null) {
      _whereClause = where;
      _whereArgs = [...args];
    } else {
      _whereClause = '($_whereClause) OR ($where)';
      _whereArgs!.addAll(args);
    }
    return this;
  }

  /// Add a WHERE condition explicitly (shorthand for andWhere)
  QueryBuilder whereRaw(String where, [List<dynamic> args = const []]) {
    return andWhere(where, args);
  }

  /// Add a GROUP BY clause
  QueryBuilder groupBy(String group) {
    _groupByClause = group;
    return this;
  }

  /// Get current where clause (for repository.count)
  String? getWhereClause() => _whereClause;

  /// Get current where args (for repository.count)
  List<dynamic>? getWhereArgs() => _whereArgs;

  /// Add an ORDER BY clause
  QueryBuilder orderBy(String column, {bool descending = false}) {
    final direction = descending ? 'DESC' : 'ASC';
    if (_orderByClause == null) {
      _orderByClause = '$column $direction';
    } else {
      _orderByClause = '$_orderByClause, $column $direction';
    }
    return this;
  }

  /// Limit the results returned
  QueryBuilder limit(int value) {
    _limitValue = value;
    return this;
  }

  /// Offset the results returned
  QueryBuilder offset(int value) {
    _offsetValue = value;
    return this;
  }

  /// Execute a SELECT query
  Future<List<Map<String, Object?>>> get() async {
    final db = await _db;

    if (_joins.isEmpty) {
      return await db.query(
        tableName,
        columns: _selectColumns,
        where: _whereClause,
        whereArgs: _whereArgs,
        orderBy: _orderByClause,
        limit: _limitValue,
        offset: _offsetValue,
      );
    } else {
      // Build raw query for joins
      final selectPart = _selectColumns != null
          ? _selectColumns!.join(', ')
          : '*';
      final joinPart = _joins.join(' ');

      final buffer = StringBuffer(
        'SELECT $selectPart FROM $tableName $joinPart',
      );

      if (_whereClause != null) {
        buffer.write(' WHERE $_whereClause');
      }
      if (_groupByClause != null) {
        buffer.write(' GROUP BY $_groupByClause');
      }
      if (_orderByClause != null) {
        buffer.write(' ORDER BY $_orderByClause');
      }
      if (_limitValue != null) {
        buffer.write(' LIMIT $_limitValue');
        if (_offsetValue != null) {
          buffer.write(' OFFSET $_offsetValue');
        }
      }

      return await db.rawQuery(buffer.toString(), _whereArgs);
    }
  }

  /// Get the first result or null
  Future<Map<String, Object?>?> first() async {
    _limitValue = 1;
    final results = await get();
    if (results.isEmpty) return null;
    return results.first;
  }

  /// Execute an INSERT operation
  Future<int> insert(Map<String, dynamic> data) async {
    final db = await _db;
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Execute an UPDATE operation
  Future<int> update(Map<String, dynamic> data) async {
    final db = await _db;
    return await db.update(
      tableName,
      data,
      where: _whereClause,
      whereArgs: _whereArgs,
    );
  }

  /// Execute a DELETE operation
  Future<int> delete() async {
    final db = await _db;
    return await db.delete(
      tableName,
      where: _whereClause,
      whereArgs: _whereArgs,
    );
  }

  /// Execute a raw query (use carefully)
  Future<List<Map<String, Object?>>> raw(
    String sql, [
    List<Object?>? args,
  ]) async {
    final db = await _db;
    return await db.rawQuery(sql, args);
  }
}
