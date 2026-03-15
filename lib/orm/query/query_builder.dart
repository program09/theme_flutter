import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:ui/orm/core/db_manager.dart';
import '../schema/table_schema.dart';

/// Fluent query builder and basic DML helpers
class QueryBuilder<T> {
  final String tableName;
  final DatabaseExecutor? executor;
  final T Function(Map<String, dynamic>)? factory;

  List<String>? _selectColumns;
  String? _whereClause;
  List<dynamic>? _whereArgs;
  String? _orderByClause;
  String? _groupByClause;
  int? _limitValue;
  int? _offsetValue;
  final List<String> _joins = [];
  final TableSchema? tableSchema;
  
  // Track relations and optional custom sub-queries
  final Map<String, QueryBuilder Function(QueryBuilder)> _relationCallbacks = {};

  QueryBuilder(this.tableName, {this.executor, this.factory, this.tableSchema});
  
  String get getTableName => tableName;

  /// Execute query and return models with relations
  Future<List<T>> findAll() async {
    print('ORM Query: Fetching results for $tableName');
    final results = await get();
    print('ORM Query: Got ${results.length} raw rows from $tableName');
    final rawMaps = results.map((m) => Map<String, dynamic>.from(m)).toList();
    
    if (_relationCallbacks.isNotEmpty && tableSchema != null) {
      await _loadRelations(rawMaps);
    }

    if (factory != null) {
      print('ORM Query: Mapping ${rawMaps.length} rows using factory');
      return rawMaps.map((map) => factory!(map)).toList();
    }
    return rawMaps as List<T>;
  }

  /// Get first result as model
  Future<T?> firstModel() async {
    _limitValue = 1;
    final results = await findAll();
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> _loadRelations(List<Map<String, dynamic>> results) async {
    if (results.isEmpty || tableSchema == null) return;

    for (final relEntry in _relationCallbacks.entries) {
      try {
        final relName = relEntry.key;
        final callback = relEntry.value;

        final relation = tableSchema!.relations.firstWhere(
          (r) => r.name == relName,
          orElse: () => throw Exception('Relation "$relName" not defined in ${tableSchema!.tableName}'),
        );

        final localKeys = results.map((r) => r[relation.localKey]).where((k) => k != null).toSet().toList();
        if (localKeys.isEmpty) continue;

        // Create sub-query builder
        var targetQuery = QueryBuilder<dynamic>(
          relation.targetSchema.tableName, 
          executor: executor,
          factory: relation.fromMap as dynamic,
          tableSchema: relation.targetSchema,
        );

        // Apply user callback
        targetQuery = callback(targetQuery);

        // Filter by foreign key
        final targetResults = await targetQuery.whereRaw(
          '${relation.foreignKey} IN (${List.filled(localKeys.length, '?').join(',')})',
          localKeys,
        ).get();

        // Group target results
        final grouped = <dynamic, List<Map<String, dynamic>>>{};
        for (final tr in targetResults) {
          final fk = tr[relation.foreignKey];
          grouped.putIfAbsent(fk, () => []).add(Map<String, dynamic>.from(tr));
        }

        // Attach to main results
        for (final mainRow in results) {
          final localKey = mainRow[relation.localKey];
          final matches = grouped[localKey] ?? [];
          
          if (relation.type.toString().contains('hasMany')) {
            mainRow[relName] = matches;
          } else {
            mainRow[relName] = matches.isNotEmpty ? matches.first : null;
          }
        }
      } catch (e) {
        print('ORM Warning: Failed to load relation "${relEntry.key}": $e');
      }
    }
  }

  // Alias for better UX
  QueryBuilder<T> include(dynamic relations) {
    if (relations is List<String>) {
      for (final r in relations) {
        _relationCallbacks[r] = (q) => q;
      }
    } else if (relations is Map<String, QueryBuilder Function(QueryBuilder)>) {
      _relationCallbacks.addAll(relations);
    } else if (relations is String) {
      _relationCallbacks[relations] = (q) => q;
    }
    return this;
  }
  
  /// Alias for include() to match other ORMs (with is reserved)
  QueryBuilder<T> with_(dynamic relations) => include(relations);

  Future<DatabaseExecutor> get _db async =>
      executor ?? await DatabaseManager().database;

  /// Select specific columns
  QueryBuilder<T> select(List<String> columns) {
    _selectColumns = columns;
    return this;
  }

  /// Add columns to the current selection
  QueryBuilder<T> addSelect(String sql) {
    _selectColumns ??= [];
    _selectColumns!.add(sql);
    return this;
  }

  /// Add a JOIN clause
  QueryBuilder<T> join(String table, String condition, {String type = 'INNER'}) {
    _joins.add('$type JOIN $table ON $condition');
    return this;
  }

  QueryBuilder<T> innerJoin(String table, String condition) {
    return join(table, condition, type: 'INNER');
  }

  QueryBuilder<T> leftJoin(String table, String condition) {
    return join(table, condition, type: 'LEFT');
  }

  /// Add a WHERE condition
  QueryBuilder<T> where(String column, dynamic value, {String operator = '='}) {
    return andWhere('$column $operator ?', [value]);
  }

  /// Add an AND WHERE condition explicitly
  QueryBuilder<T> andWhere(String where, [List<dynamic> args = const []]) {
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
  QueryBuilder<T> orWhere(String where, [List<dynamic> args = const []]) {
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
  QueryBuilder<T> whereRaw(String where, [List<dynamic> args = const []]) {
    return andWhere(where, args);
  }

  /// Add a GROUP BY clause
  QueryBuilder<T> groupBy(String group) {
    _groupByClause = group;
    return this;
  }

  /// Get current where clause (for repository.count)
  String? getWhereClause() => _whereClause;

  /// Get current where args (for repository.count)
  List<dynamic>? getWhereArgs() => _whereArgs;

  /// Add an ORDER BY clause
  QueryBuilder<T> orderBy(String column, {bool descending = false}) {
    final direction = descending ? 'DESC' : 'ASC';
    if (_orderByClause == null) {
      _orderByClause = '$column $direction';
    } else {
      _orderByClause = '$_orderByClause, $column $direction';
    }
    return this;
  }

  /// Limit the results returned
  QueryBuilder<T> limit(int value) {
    _limitValue = value;
    return this;
  }

  /// Offset the results returned
  QueryBuilder<T> offset(int value) {
    _offsetValue = value;
    return this;
  }

  /// Get requested relations and their config callbacks
  Map<String, QueryBuilder Function(QueryBuilder)> get relationCallbacks => _relationCallbacks;

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
