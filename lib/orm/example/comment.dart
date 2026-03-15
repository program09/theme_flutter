import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';
import '../schema/foreign_key.dart';

class Comment extends Model {
  final int? id;
  final int postId;
  final String text;

  Comment.empty() : this(postId: 0, text: '');

  Comment({
    this.id,
    required this.postId,
    required this.text,
  });

  static TableSchema get tableSchema => TableSchema(
        tableName: 'comments',
        fields: [
          Field.integer('id', isPrimaryKey: true, autoIncrement: true),
          Field.integer('post_id', isNullable: false),
          Field.text('text', isNullable: false),
        ],
        foreignKeys: [
          ForeignKey(
            column: 'post_id', 
            referenceTable: 'posts', 
            referenceColumn: 'id',
            onDelete: 'CASCADE',
          )
        ],
      );

  @override
  TableSchema get instanceTableSchema => Comment.tableSchema;

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'text': text,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      postId: map['post_id'] as int,
      text: map['text'] as String,
    );
  }
}
