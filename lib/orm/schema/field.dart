enum FieldType {
  integer('INTEGER'),
  real('REAL'),
  text('TEXT'),
  blob('BLOB'),
  boolean('INTEGER'),
  datetime('TEXT'),
  json('TEXT'),
  point('TEXT'),
  polygon('TEXT'),
  line('TEXT'),
  multiline('TEXT');

  final String sqlKeyword;
  const FieldType(this.sqlKeyword);
}

class Field {
  final String name;
  final FieldType type;
  final bool isPrimaryKey;
  final bool autoIncrement;
  final bool isNullable;
  final bool unique;
  final dynamic defaultValue;

  const Field(
    this.name,
    this.type, {
    this.isPrimaryKey = false,
    this.autoIncrement = false,
    this.isNullable = true,
    this.unique = false,
    this.defaultValue,
  });

  /// Generate the SQL portion for this field type
  String toSql() {
    final buffer = StringBuffer();
    buffer.write('$name ${type.sqlKeyword}');

    if (isPrimaryKey) {
      buffer.write(' PRIMARY KEY');
      if (autoIncrement) {
        buffer.write(' AUTOINCREMENT');
      }
    }

    if (!isNullable && !isPrimaryKey) {
      buffer.write(' NOT NULL');
    }

    if (unique) {
      buffer.write(' UNIQUE');
    }

    if (defaultValue != null) {
      buffer.write(' DEFAULT $formattedDefault');
    }

    return buffer.toString();
  }

  String get formattedDefault {
    if (defaultValue is String) {
      final escapedStr = (defaultValue as String).replaceAll("'", "''");
      return "'$escapedStr'"; // Escapes simple quotes
    } else if (defaultValue is bool) {
      return defaultValue == true ? '1' : '0';
    } else {
      return '$defaultValue';
    }
  }

  // Pre-defined factory constructors
  factory Field.integer(String name, {bool isPrimaryKey = false, bool autoIncrement = false, bool isNullable = true, bool unique = false, int? defaultValue}) {
    return Field(name, FieldType.integer, isPrimaryKey: isPrimaryKey, autoIncrement: autoIncrement, isNullable: isNullable, unique: unique, defaultValue: defaultValue);
  }

  factory Field.text(String name, {bool isPrimaryKey = false, bool isNullable = true, bool unique = false, String? defaultValue}) {
    return Field(name, FieldType.text, isPrimaryKey: isPrimaryKey, isNullable: isNullable, unique: unique, defaultValue: defaultValue);
  }

  factory Field.real(String name, {bool isNullable = true, bool unique = false, double? defaultValue}) {
    return Field(name, FieldType.real, isNullable: isNullable, unique: unique, defaultValue: defaultValue);
  }

  factory Field.boolean(String name, {bool isNullable = true, bool? defaultValue}) {
    return Field(name, FieldType.boolean, isNullable: isNullable, defaultValue: defaultValue);
  }

  factory Field.datetime(String name, {bool isNullable = true, DateTime? defaultValue}) {
    return Field(name, FieldType.datetime, isNullable: isNullable, defaultValue: defaultValue?.toIso8601String());
  }

  factory Field.json(String name, {bool isNullable = true}) {
    return Field(name, FieldType.json, isNullable: isNullable);
  }

  factory Field.point(String name, {bool isNullable = true}) {
    return Field(name, FieldType.point, isNullable: isNullable);
  }

  factory Field.polygon(String name, {bool isNullable = true}) {
    return Field(name, FieldType.polygon, isNullable: isNullable);
  }

  // Converts a database raw value to the corresponding Dart type
  dynamic parseFromDb(dynamic dbValue) {
    if (dbValue == null) return null;

    switch (type) {
      case FieldType.boolean:
        return dbValue == 1;
      case FieldType.datetime:
        return DateTime.parse(dbValue as String);
      case FieldType.json:
        // Users should handle actual JSON parsing if needed, 
        // ORM provides it as string/dynamic
        return dbValue; 
      default:
        return dbValue;
    }
  }

  // Converts a Dart value to the corresponding database raw type
  dynamic formatToDb(dynamic dartValue) {
    if (dartValue == null) return null;

    switch (type) {
      case FieldType.boolean:
        return (dartValue as bool) ? 1 : 0;
      case FieldType.datetime:
        return (dartValue as DateTime).toIso8601String();
      case FieldType.json:
        // No auto-serialization to avoid dependency on dart:convert here if not needed
        return dartValue; 
      default:
        return dartValue; 
    }
  }
}
