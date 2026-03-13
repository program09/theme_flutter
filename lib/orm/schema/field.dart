enum FieldType {
  integer('INTEGER'),
  real('REAL'),
  text('TEXT'),
  blob('BLOB'),
  boolean('INTEGER'), // SQLite doesn't have a boolean type, uses 0/1 natively
  datetime('TEXT'); // Stored as ISO8601 string

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

  // Pre-defined factory constructors for common types to keep user code simple
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

  // Converts a database raw value to the corresponding Dart type
  dynamic parseFromDb(dynamic dbValue) {
    if (dbValue == null) return null;

    switch (type) {
      case FieldType.boolean:
        return dbValue == 1;
      case FieldType.datetime:
        return DateTime.parse(dbValue as String);
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
      default:
        return dartValue; 
    }
  }
}
