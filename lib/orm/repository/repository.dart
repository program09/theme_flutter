import '../query/query_builder.dart';
import '../schema/table_schema.dart';
import '../models/model.dart';

class Repository<T extends Model> {
  final TableSchema tableSchema;
  final T Function(Map<String, dynamic>) fromMap;

  Repository(this.tableSchema, this.fromMap);

  QueryBuilder get query => QueryBuilder(tableSchema.tableName);

  Future<int> insert(T item) async {
    return await query.insert(item.toMap());
  }

  Future<List<T>> findAll() async {
    final results = await query.get();
    return results.map((map) => fromMap(map)).toList();
  }

  Future<int> update(T item) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    final map = item.toMap();
    final pkValue = map[pkField.name];
    return await QueryBuilder(tableSchema.tableName)
        .where(pkField.name, pkValue)
        .update(map);
  }

  Future<int> delete(T item) async {
    final pkField = tableSchema.fields.firstWhere((f) => f.isPrimaryKey);
    final map = item.toMap();
    final pkValue = map[pkField.name];
    return await QueryBuilder(tableSchema.tableName)
        .where(pkField.name, pkValue)
        .delete();
  }
}
