import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';
import '../schema/foreign_key.dart';

class Post extends Model {
  final int? id;
  final int userId;
  final String title;
  final String content;

  Post.empty() : this(userId: 0, title: '', content: '');

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
  });

  static TableSchema get tableSchema => TableSchema(
        tableName: 'posts',
        fields: [
          Field.integer('id', isPrimaryKey: true, autoIncrement: true),
          Field.integer('user_id', isNullable: false),
          Field.text('title', isNullable: false),
          Field.text('content', isNullable: false),
        ],
        foreignKeys: [
          ForeignKey(
            column: 'user_id', 
            referenceTable: 'users', 
            referenceColumn: 'id',
            onDelete: 'CASCADE',
          )
        ],
        uniqueTogether: [
          ['user_id', 'title'], // A user cannot have two posts with exactly the same title
        ]
      );

  @override
  TableSchema get instanceTableSchema => Post.tableSchema;

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }
}
