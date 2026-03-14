# Professional Flutter ORM Documentation

A comprehensive guide to using the custom ORM, built for efficiency, security, and flexibility.

---

## 🛠️ 1. Schema Definitions (Tables & Columns)
# 🚀 Flutter Encrypted ORM

Un ORM potente, cifrado (SQLCipher) y fácil de usar para Flutter. Soporta tipos avanzados, migraciones automáticas, soft deletes y múltiples instancias centralizadas.

## 📦 Instalación

Añade estas dependencias en tu `pubspec.yaml`:

```yaml
dependencies:
  sqflite_sqlcipher: latest
  path: latest
  synchronized: latest
```

---

## 🏗️ 1. Definición de Modelos

Tus modelos deben extender de `Model` y definir un `TableSchema` estático.

```dart
class User extends Model {
  final int? id;
  final String name;
  final Map<String, dynamic>? metadata; // JSON

  User({this.id, required this.name, this.metadata});

  // 1. Esquema de la tabla
  static TableSchema get tableSchema => TableSchema(
    tableName: 'users',
    fields: [
      Field.integer('id', isPrimaryKey: true, autoIncrement: true),
      Field.text('name', isNullable: false),
      Field.json('metadata'), // Tipo JSON soportado
      Field.datetime('created_at'),
    ],
    uniqueTogether: ['name'], // Restricciones únicas
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'metadata': metadata,
  };

  static User fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    metadata: map['metadata'],
  );

  @override
  TableSchema get instanceTableSchema => tableSchema;
}
```

---

## 🔐 2. Inicialización Centralizada

Usa un `DatabaseHelper` para centralizar la configuración del ORM.

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    
    // El ORM maneja apertura, cifrado y tablas automáticamente
    _db = await DatabaseManager().initialize(
      DatabaseConfig(
        dbName: 'app.db',
        version: 1,
        password: 'tu_clave_segura',
        enableTimestamps: true, // Auto created_at, updated_at
        tables: [User.tableSchema, Post.tableSchema], // Registra tus tablas
        onUpgrade: (db, old, newV) async {
          // Migraciones usando el ORM
          if (old < 2) {
            await User.tableSchema.addColumn(db, 'is_active', Field.integer('is_active', defaultValue: 1));
          }
        },
      ),
    );
    return _db!;
  }
}
```

---

## 🏛️ 3. Operaciones de Repositorio

El `Repository<T>` te da superpoderes para manejar tus datos.

```dart
final db = await DatabaseHelper().database;
final userRepo = Repository<User>(User.tableSchema, User.fromMap, executor: db);

// Insertar
await userRepo.insert(User(name: 'Alice', metadata: {'age': 25}));

// Buscar
List<User> users = await userRepo.findAll();
User? user = await userRepo.findById(1);

// Query Builder Avanzado
final posts = await QueryBuilder('posts')
    .select(['posts.id', 'posts.title', 'users.name as author'])
    .innerJoin('users', 'users.id = posts.user_id')
    .where('posts.is_active', 1)
    .orderBy('posts.created_at', descending: true)
    .get();
```

---

## 📱 4. Ejemplo Práctico en Pantalla (UI)

Usa `FutureBuilder` o `StreamBuilder` para mostrar datos de forma reactiva.

```dart
class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuarios")),
      body: FutureBuilder<List<User>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text("ID: ${user.id}"),
                onTap: () => _deleteUser(user.id!),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<User>> _fetchUsers() async {
    final db = await DatabaseHelper().database;
    final repo = Repository<User>(User.tableSchema, User.fromMap, executor: db);
    return await repo.findAll();
  }
}
```

---

## 🌟 Características Avanzadas

### Múltiples Instancias
Puedes manejar bases de datos separadas (ej. Logs vs Datos de Usuario):
```dart
final logsManager = DatabaseManager('logs');
await logsManager.initialize(DatabaseConfig(dbName: 'logs.db', ...));
```

### Tipos Geoespaciales y JSON
El ORM mapea automáticamente `JSON`, `POINT`, `POLYGON`, etc.
```dart
Field.point('location');
Field.json('settings');
```

### Soft Deletes
Si habilitas timestams, `repo.softDelete(id)` marcará la fila como borrada y `findAll()` la ignorará automáticamente.


## 🔌 3. Dependency Injection & Multi-Database

The ORM is fully decoupled. You can inject a specific database instance (or a transaction) into any Repository or QueryBuilder.

### Using Multiple Databases
If your app uses several databases, simply pass the `executor` to the repository:

```dart
final db1 = await openDatabase('db1.db');
final db2 = await openDatabase('db2.db');

final repo1 = Repository<User>(User.tableSchema, User.fromMap, executor: db1);
final repo2 = Repository<User>(User.tableSchema, User.fromMap, executor: db2);
```

### Transactions
Since `Repository` accepts a `DatabaseExecutor`, you can perform operations inside a transaction:

```dart
final db = await DatabaseManager().database;

await db.transaction((txn) async {
  final repo = Repository<User>(User.tableSchema, User.fromMap, executor: txn);
  await repo.insert(User(name: 'Alice'));
  await repo.insert(User(name: 'Bob'));
  // Everything inside txn is atomic
});
```

### Decoupling (Custom Database Helpers)
If you prefer managing your own database lifecycle (e.g. `DatabaseHelper`), tell the ORM to use your instance:

```dart
class MyHelper {
  Future<void> init() async {
    final db = await openDatabase(...);
    
    // Link ORM to your managed DB
    DatabaseManager().useExternalDatabase(db);
    
    // ORM will use 'db' for all global operations
    await DatabaseManager().initialize(DatabaseConfig(...));
  }
}
```

---

## 🔍 4. Advanced QueryBuilder (`addSelect`)

The `QueryBuilder` allows injecting raw SQL directly into the selection or where clauses.

### Subqueries and Raw Selects
Use `addSelect` to add calculated fields or subqueries:

```dart
final posts = await QueryBuilder('posts')
    .select(['posts.id', 'posts.title'])
    // Inject a subquery or custom SQL
    .addSelect('(SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id) AS comment_count')
    .innerJoin('users', 'users.id = posts.user_id')
    .where('posts.is_active', 1)
    .get();

// Access the raw data
final commentCount = posts.first['comment_count'];
```

---

## 🔄 4. Initialization & Migrations

Register everything in `DatabaseConfig`. Use the `onUpgrade` callback to evolve the schema as your app grows.

```dart
await DatabaseManager().initialize(
  DatabaseConfig(
    dbName: 'app.db',
    version: 2,
    tables: [User.tableSchema, Post.tableSchema], // All tables here
    onUpgrade: (db, old, new) async {
      if (old < 2) {
        // Add a new column to an existing table
        await User.tableSchema.addColumn(db, 'is_active', Field.integer('is_active', defaultValue: 1));
      }
    },
  ),
);
```

