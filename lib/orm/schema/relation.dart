import 'table_schema.dart';

enum RelationType {
  hasOne,
  hasMany,
  belongsTo,
}

class Relation {
  final String name;
  final RelationType type;
  final TableSchema Function() targetSchemaGetter;
  final String foreignKey;
  final String localKey;
  final Function fromMap;

  Relation({
    required this.name,
    required this.type,
    required this.targetSchemaGetter,
    required this.foreignKey,
    this.localKey = 'id',
    required this.fromMap,
  });

  TableSchema get targetSchema => targetSchemaGetter();

  /// Factory for HasOne relation
  static Relation hasOne({
    required String name,
    required TableSchema Function() targetSchema,
    required String foreignKey,
    String localKey = 'id',
    required Function fromMap,
  }) {
    return Relation(
      name: name,
      type: RelationType.hasOne,
      targetSchemaGetter: targetSchema,
      foreignKey: foreignKey,
      localKey: localKey,
      fromMap: fromMap,
    );
  }

  /// Factory for HasMany relation
  static Relation hasMany({
    required String name,
    required TableSchema Function() targetSchema,
    required String foreignKey,
    String localKey = 'id',
    required Function fromMap,
  }) {
    return Relation(
      name: name,
      type: RelationType.hasMany,
      targetSchemaGetter: targetSchema,
      foreignKey: foreignKey,
      localKey: localKey,
      fromMap: fromMap,
    );
  }

  /// Factory for BelongsTo relation
  static Relation belongsTo({
    required String name,
    required TableSchema Function() targetSchema,
    required String foreignKey,
    String localKey = 'id',
    required Function fromMap,
  }) {
    return Relation(
      name: name,
      type: RelationType.belongsTo,
      targetSchemaGetter: targetSchema,
      foreignKey: foreignKey,
      localKey: localKey,
      fromMap: fromMap,
    );
  }
}
