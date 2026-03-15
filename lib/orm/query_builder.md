# 🛠️ ORM Query Builder Guide

El `QueryBuilder` es el motor central del ORM que permite construir consultas SQL complejas de forma fluida y segura.

---

## 🔍 1. Selección de Datos (SELECT)

### Selección Básica
Para obtener todos los registros de una tabla:
```dart
final results = await QueryBuilder('users').get();
```

### Columnas Específicas
```dart
final results = await QueryBuilder('users')
    .select(['id', 'name', 'email'])
    .get();
```

### Columnas Adicionales o SQL Raw
```dart
final results = await QueryBuilder('users')
    .select(['id', 'name'])
    .addSelect('COUNT(*) OVER() as total_count')
    .get();
```

---

## 🥗 2. Filtrado (WHERE)

### Filtros Básicos
```dart
// Equality (default)
query.where('age', 25);

// Custom operator
query.where('age', 18, operator: '>=');
```

### Filtros con Operadores Lógicos (AND / OR)
```dart
query.where('is_active', 1)
     .andWhere('age > ?', [18])
     .orWhere('role = ?', ['admin']);
```

### Filtros Raw (SQL Directo)
```dart
query.whereRaw('deleted_at IS NULL AND (name LIKE ? OR email LIKE ?)', ['%Alice%', '%@gmail.com%']);
```

---

## 📑 3. Ordenamiento y Paginación

### Ordenar Resultados
```dart
query.orderBy('created_at', descending: true);
query.orderBy('name'); // Ascendente por defecto
```

### Límite y Offset (Paginación)
```dart
query.limit(10).offset(20);
```

---

## 🔗 4. Joins y Relaciones

### Inner y Left Joins
```dart
final results = await QueryBuilder('posts')
    .innerJoin('users', 'users.id = posts.user_id')
    .select(['posts.*', 'users.name as author_name'])
    .get();
```

### Carga de Relaciones (Eager Loading)
Si defines relaciones en tu `TableSchema`, puedes cargarlas automáticamente:
```dart
// Cargar relación 'posts' del usuario
final users = await userRepository.query
    .include('posts')
    .findAll();

// Con filtros en la relación
final users = await userRepository.query
    .with_({
      'posts': (q) => q.where('is_published', 1).orderBy('created_at', descending: true)
    })
    .findAll();
```

---

## 💾 5. Operaciones DML (INSERT, UPDATE, DELETE)

### Insertar
```dart
await QueryBuilder('users').insert({
  'name': 'Bob',
  'age': 30
});
```

### Actualizar con Filtros
```dart
await QueryBuilder('users')
    .where('id', 1)
    .update({'name': 'Robert'});
```

### Eliminar con Filtros
```dart
await QueryBuilder('users')
    .where('age', 18, operator: '<')
    .delete();
```

---

## ⚡ 6. Helpers de Ejecución

- `get()`: Ejecuta la consulta y retorna `List<Map<String, dynamic>>`.
- `findAll()`: Ejecuta y mapea a modelos (usado en Repositorios).
- `first()`: Retorna el primer resultado como `Map`.
- `firstModel()`: Retorna el primer resultado mapeado a un modelo.
- `raw(sql, args)`: Ejecuta SQL puro si es necesario.

---

## 🏛️ 7. Uso desde el Repository

El `Repository` expone una propiedad `.query` que hereda los filtros automáticos (como soft deletes).

```dart
final userRepo = Repository<User>(User.tableSchema, User.fromMap);

// El repositorio ya aplica 'deleted_at IS NULL' si existe
final activeUsers = await userRepo.query
    .where('age', 21, operator: '>')
    .findAll();
```
