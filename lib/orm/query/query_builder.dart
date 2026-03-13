import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:ui/orm/core/db_manager.dart';

class QueryBuilder {
  final String tableName;
  
  List<String>? _selectColumns;
  String? _whereClause;
  List<dynamic>? _whereArgs;
  String? _orderByClause;
  int? _limitValue;
  int? _offsetValue;
  final List<String> _joins = [];

  QueryBuilder(this.tableName);

  /// Select specific columns
  QueryBuilder select(List<String> columns) {
    _selectColumns = columns;
    return this;
  }

  /// Add a JOIN clause
  QueryBuilder join(String table, String condition, {String type = 'INNER'}) {
    _joins.add('$type JOIN $table ON $condition');
    return this;
  }

  /// Add a WHERE condition
  QueryBuilder where(String column, dynamic value, {String operator = '='}) {
    if (_whereClause == null) {
      _whereClause = '$column $operator ?';
      _whereArgs = [value];
    } else {
      _whereClause = '$_whereClause AND $column $operator ?';
      _whereArgs!.add(value);
    }
    return this;
  }
  
  /// Add a WHERE condition explicitly
  QueryBuilder whereRaw(String where, List<dynamic> args) {
    if (_whereClause == null) {
      _whereClause = where;
      _whereArgs = args;
    } else {
      _whereClause = '$_whereClause AND $where';
      _whereArgs!.addAll(args);
    }
    return this;
  }

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
    final db = await DatabaseManager().database;

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
      final selectPart = _selectColumns != null ? _selectColumns!.join(', ') : '*';
      final joinPart = _joins.join(' ');
      
      var sql = 'SELECT $selectPart FROM $tableName $joinPart';
      
      if (_whereClause != null) {
        sql += ' WHERE $_whereClause';
      }
      if (_orderByClause != null) {
        sql += ' ORDER BY $_orderByClause';
      }
      if (_limitValue != null) {
        if (_offsetValue != null) {
          sql += ' LIMIT $_limitValue OFFSET $_offsetValue';
        } else {
          sql += ' LIMIT $_limitValue';
        }
      }
      
      return await db.rawQuery(sql, _whereArgs);
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
    final db = await DatabaseManager().database;
    return await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Execute an UPDATE operation
  Future<int> update(Map<String, dynamic> data) async {
    final db = await DatabaseManager().database;
    return await db.update(
      tableName,
      data,
      where: _whereClause,
      whereArgs: _whereArgs,
    );
  }

  /// Execute a DELETE operation
  Future<int> delete() async {
    final db = await DatabaseManager().database;
    return await db.delete(
      tableName,
      where: _whereClause,
      whereArgs: _whereArgs,
    );
  }
}
