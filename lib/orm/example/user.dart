import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';

class User extends Model {
  final int? id;
  final String name;
  final int age;
  final bool isActive;
  final DateTime? createdAt;

  User({
    this.id,
    required this.name,
    required this.age,
    this.isActive = true,
    this.createdAt,
  });

  @override
  TableSchema get tableSchema => TableSchema(
        tableName: 'users',
        fields: [
          Field('id', FieldType.integer, isPrimaryKey: true, autoIncrement: true),
          Field('name', FieldType.text, isNullable: false),
          Field('age', FieldType.integer, isNullable: false),
          Field('is_active', FieldType.integer, isNullable: false),
          Field('created_at', FieldType.text, isNullable: true),
        ],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      isActive: (map['is_active'] as int) == 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
    );
  }
}
