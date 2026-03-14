import '../models/model.dart';
import '../schema/table_schema.dart';
import '../schema/field.dart';
import '../schema/foreign_key.dart';

class Profile extends Model {
  final int? id;
  final int userId;
  final String bio;
  final String? location; // Store as Point string or JSON

  Profile({this.id, required this.userId, required this.bio, this.location});

  static TableSchema get tableSchema => TableSchema(
    tableName: 'profiles',
    fields: [
      Field.integer('id', isPrimaryKey: true, autoIncrement: true),
      Field.integer('userId', isNullable: false, unique: true),
      Field.text('bio'),
      Field.point('location'),
    ],
    foreignKeys: [
      ForeignKey(
        column: 'userId',
        referenceTable: 'users',
        referenceColumn: 'id',
        onDelete: 'CASCADE',
      )
    ],
  );

  @override
  TableSchema get instanceTableSchema => Profile.tableSchema;

  @override
  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'userId': userId,
    'bio': bio,
    'location': location,
  };

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
    id: map['id'] as int?,
    userId: map['userId'] as int,
    bio: map['bio'] as String,
    location: map['location'] as String?,
  );
}
