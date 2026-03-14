import 'dart:convert';
import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';
import '../schema/foreign_key.dart';

class Product extends Model {
  final int? id;
  final String name;
  final double price;
  final int categoryId;
  final Map<String, dynamic>? metadata;

  Product({this.id, required this.name, required this.price, required this.categoryId, this.metadata});

  static TableSchema get tableSchema => TableSchema(
    tableName: 'products',
    fields: [
      Field.integer('id', isPrimaryKey: true, autoIncrement: true),
      Field.text('name', isNullable: false),
      Field.real('price', isNullable: false),
      Field.integer('category_id', isNullable: false),
      Field.json('metadata'),
    ],
    foreignKeys: [
      ForeignKey(
        column: 'category_id',
        referenceTable: 'categories',
        referenceColumn: 'id',
        onDelete: 'CASCADE',
      )
    ],
  );

  @override
  TableSchema get instanceTableSchema => Product.tableSchema;

  @override
  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'price': price,
    'category_id': categoryId,
    'metadata': metadata != null ? jsonEncode(metadata) : null,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'] as int?,
    name: map['name'] as String,
    price: (map['price'] as num).toDouble(),
    categoryId: map['category_id'] as int,
    metadata: map['metadata'] != null ? jsonDecode(map['metadata'] as String) as Map<String, dynamic> : null,
  );
}
