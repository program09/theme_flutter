# Custom Flutter ORM

This is a lightweight object-relational mapping (ORM) library built for Flutter using `sqflite_sqlcipher`. 

## Features
* Automatic table creation based on strictly-typed schemas.
* Type-safe CRUD operations.
* Fluent Query Builder for constructing complex where clauses, limits, offsets, and ordering.
* Model-driven design for handling row mappings smoothly.

## Setup

Before you use the database, you must properly initialize `DatabaseManager` with a `DatabaseConfig` and a list of your models.

```dart
import 'package:ui/orm/core/db_manager.dart';
import 'package:ui/orm/core/database_config.dart';
// import your models here

void main() async {
  // Pass configuration and the list of models to automatically create the desired tables.
  await DatabaseManager().initialize(
    const DatabaseConfig(
      dbName: 'my_app.db', 
      version: 1, 
      password: 'my_super_secure_password' // Optional: SQLCipher encryption key
    ),
    [
      User(name: '', age: 0), // Base instances for generating schemas
    ], 
  );
}
```

## Creating a Model

All database models must extend the `Model` base class.

1. Implement the `tableSchema` getter using `TableSchema` and `Field`.
2. Implement the `toMap()` function for SQL extraction.
3. Provide a factory `fromMap(Map<String, dynamic> map)` static/factory method for inflation.

```dart
import 'package:ui/orm/models/model.dart';
import 'package:ui/orm/schema/table_schema.dart';
import 'package:ui/orm/schema/field.dart';

class User extends Model {
  final int? id;
  final String name;
  final int age;
  final bool isActive;

  User({this.id, required this.name, required this.age, this.isActive = true});

  @override
  TableSchema get tableSchema => TableSchema(
        tableName: 'users',
        fields: [
          Field.integer('id', isPrimaryKey: true, autoIncrement: true),
          Field.text('name', isNullable: false),
          Field.integer('age', isNullable: false),
          Field.boolean('is_active', isNullable: false),
        ],
      );

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'age': age,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String,
      age: map['age'] as int,
      isActive: (map['is_active'] as int) == 1,
    );
  }
}
```

### Supported Field Types

The `Field` class provides several factory constructors for common SQL types:
* `Field.integer(name)` - Used for standard Ints, IDs, auto-increments.
* `Field.text(name)` - Used for Strings.
* `Field.real(name)` - Used for floating/double precision.
* `Field.boolean(name)` - Virtual type mapping `bool` under the hood to `INTEGER (0 or 1)`.
* `Field.datetime(name)` - Virtual type mapping `DateTime` to ISO-8601 strings.

## Database Operations

Operations are driven by the generic `Repository<T>`. You initialize a repository with the table schema and your model's Map inflating factory.

```dart
final userRepository = Repository<User>(
  User(name: '', age: 0).tableSchema, 
  User.fromMap,
);
```

### Insert
```dart
final newUserId = await userRepository.insert(User(name: 'Alice', age: 25));
```

### Update
Update expects the whole instance containing its assigned Primary Key.
```dart
final aliceModified = User(id: 1, name: 'Alice', age: 26);
await userRepository.update(aliceModified);
```

### Delete 
```dart
await userRepository.delete(userToDelete);
```

### Querying

You can fetch all results instantly using the base `.findAll()`.
```dart
final allUsers = await userRepository.findAll();
```

For advanced filters, use the Query Builder logic via `.query`:

```dart
// Basic where filter
final activeUsers = await userRepository.query
   .where('is_active', 1)
   .orderBy('age', descending: true)
   .limit(10)
   .get();

// Retrieve first matching object
final bob = await userRepository.query.where('name', 'Bob').first();
```
