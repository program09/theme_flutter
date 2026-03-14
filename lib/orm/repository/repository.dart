import 'package:sqflite_sqlcipher/sqflite.dart';
import '../core/db_manager.dart';
import '../models/model.dart';
import '../query/query_builder.dart';
import '../schema/table_schema.dart';

class Repository<T extends Model> {
  final TableSchema tableSchema;
  final T Function(Map<String, dynamic>) fromMap;
  final DatabaseExecutor? executor;

  Repository(this.tableSchema, this.fromMap, {this.executor});

  Future<DatabaseExecutor> get _db async =>
      executor ?? await DatabaseManager().database;

  QueryBuilder get query {
    final q = QueryBuilder(tableSchema.tableName, executor: executor);
    // Automatically filter out soft-deleted items if the column exists
    if (tableSchema.fields.any((f) => f.name == 'deleted_at')) {
      q.whereRaw('deleted_at IS NULL', []);
    }
    return q;
  }

  /// Get query builder including soft-deleted items
  QueryBuilder get queryWithTrashed =>
      QueryBuilder(tableSchema.tableName, executor: executor);

  Future<int> insert(T item) async {
    final map = item.toMap();
    // Auto timestamps
    if (tableSchema.fields.any((f) => f.name == 'created_at')) {
      map['created_at'] = DateTime.now().toIso8601String();
    }
    if (tableSchema.fields.any((f) => f.name == 'updated_at')) {
      map['updated_at'] = DateTime.now().toIso8601String();
    }
    return await query.insert(map);
  }

  Future<List<T>> findAll() async {
    final results = await query.get();
    return results
        .map((map) => fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<T?> findById(dynamic id) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    final result = await query.where(pkField.name, id).first();
    return result != null ? fromMap(Map<String, dynamic>.from(result)) : null;
  }

  Future<List<T>> findWhere(
    String column,
    dynamic value, {
    String operator = '=',
  }) async {
    final results = await query.where(column, value, operator: operator).get();
    return results
        .map((map) => fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<int> count({String? where, List<dynamic>? whereArgs}) async {
    final q = query;
    if (where != null) {
      q.andWhere(where, whereArgs ?? []);
    }
    final db = await _db;
    final whereStr = q.getWhereClause() != null
        ? ' WHERE ${q.getWhereClause()}'
        : '';
    final rows = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM ${tableSchema.tableName}$whereStr',
      q.getWhereArgs(),
    );
    return (rows.first['cnt'] as int?) ?? 0;
  }

  /// Update an item. If [fields] is provided, only those fields are updated.
  Future<int> update(T item, {List<String>? fields}) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    var map = item.toMap();

    if (fields != null) {
      map = Map.fromEntries(
        map.entries.where(
          (e) => fields.contains(e.key) || e.key == pkField.name,
        ),
      );
    }

    if (tableSchema.fields.any((f) => f.name == 'updated_at')) {
      map['updated_at'] = DateTime.now().toIso8601String();
    }

    final pkValue = map[pkField.name];
    return await queryWithTrashed.where(pkField.name, pkValue).update(map);
  }

  /// Delete an item by ID
  Future<int> delete(dynamic id) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    return await queryWithTrashed.where(pkField.name, id).delete();
  }

  Future<int> deleteAll() async {
    return await queryWithTrashed.delete();
  }

  Future<int> deleteWhere(String where, [List<dynamic> args = const []]) async {
    return await queryWithTrashed.whereRaw(where, args).delete();
  }

  Future<int> deleteWhereRaw(
    String where, [
    List<dynamic> args = const [],
  ]) async {
    return await deleteWhere(where, args);
  }

  /// Soft delete an item by assigning deleted_at
  Future<int> softDelete(dynamic id) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    if (!tableSchema.fields.any((f) => f.name == 'deleted_at')) {
      throw Exception(
        'Table does not support soft delete (missing deleted_at column)',
      );
    }
    return await queryWithTrashed.where(pkField.name, id).update({
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> softDeleteAll() async {
    if (!tableSchema.fields.any((f) => f.name == 'deleted_at')) {
      throw Exception('Table does not support soft delete');
    }
    return await queryWithTrashed.update({
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> softDeleteWhere(
    String where, [
    List<dynamic> args = const [],
  ]) async {
    if (!tableSchema.fields.any((f) => f.name == 'deleted_at')) {
      throw Exception('Table does not support soft delete');
    }
    return await queryWithTrashed.whereRaw(where, args).update({
      'deleted_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> softDeleteWhereRaw(
    String where, [
    List<dynamic> args = const [],
  ]) async {
    return await softDeleteWhere(where, args);
  }
}
