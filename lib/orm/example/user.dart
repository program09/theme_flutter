import 'dart:convert';
import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';
import '../schema/relation.dart';
import 'post.dart';
import 'profile.dart';

class User extends Model {
  final int? id;
  final String name;
  final int age;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  
  // Relations
  final List<Post>? posts;
  final Profile? profile;

  User.empty() : this(name: '', age: 0, isActive: false, createdAt: null);

  User({
    this.id,
    required this.name,
    required this.age,
    this.isActive = true,
    this.metadata,
    this.createdAt,
    this.posts,
    this.profile,
  });

  static TableSchema get tableSchema => TableSchema(
        tableName: 'users',
        fields: [
          Field.integer('id', isPrimaryKey: true, autoIncrement: true),
          Field.text('name', isNullable: false),
          Field.integer('age', isNullable: false),
          Field.integer('is_active', isNullable: false),
          Field.json('metadata'),
          Field.text('created_at', isNullable: true),
        ],
        relations: [
          Relation.hasMany(
            name: 'posts',
            targetSchema: () => Post.tableSchema,
            foreignKey: 'user_id',
            fromMap: (map) => Post.fromMap(map),
          ),
          Relation.hasOne(
            name: 'profile',
            targetSchema: () => Profile.tableSchema,
            foreignKey: 'userId',
            fromMap: (map) => Profile.fromMap(map),
          ),
        ],
      );

  @override
  TableSchema get instanceTableSchema => User.tableSchema;

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'is_active': isActive ? 1 : 0,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      isActive: (map['is_active'] as int) == 1,
      metadata: map['metadata'] != null ? jsonDecode(map['metadata'] as String) as Map<String, dynamic> : null,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
      posts: (map['posts'] as List?)?.map((p) => Post.fromMap(Map<String, dynamic>.from(p))).toList(),
      profile: map['profile'] != null ? Profile.fromMap(Map<String, dynamic>.from(map['profile'])) : null,
    );
  }
}
