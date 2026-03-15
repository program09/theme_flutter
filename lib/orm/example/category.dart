import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';

class Category extends Model {
  final int? id;
  final String name;
  final String? description;

  Category({this.id, required this.name, this.description});

  static TableSchema get tableSchema => TableSchema(
    tableName: 'categories',
    fields: [
      Field.integer('id', isPrimaryKey: true, autoIncrement: true),
      Field.text('name', isNullable: false, unique: true),
      Field.text('description'),
    ],
  );

  @override
  TableSchema get instanceTableSchema => Category.tableSchema;

  @override
  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'description': description,
  };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int?,
    name: map['name'] as String,
    description: map['description'] as String?,
  );
}
