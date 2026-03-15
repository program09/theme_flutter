import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:ui/orm/core/db_manager.dart';
import 'package:ui/orm/core/database_config.dart';
import 'package:ui/orm/repository/repository.dart';
import 'package:ui/orm/schema/table_schema.dart';
import 'package:ui/orm/schema/field.dart';
import 'package:ui/orm/schema/foreign_key.dart';
import 'user.dart';
import 'post.dart';
import 'comment.dart';
import 'category.dart';
import 'product.dart';
import 'profile.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    // Definimos esquemas intermedios o adicionales aquí para mantener limpia la UI
    final userRolesSchema = TableSchema(
      tableName: 'user_roles',
      fields: [
        Field.integer('user_id', isNullable: false),
        Field.text('role_name', isNullable: false),
      ],
      foreignKeys: [
        ForeignKey(
          column: 'user_id',
          referenceTable: 'users',
          referenceColumn: 'id',
          onDelete: 'CASCADE',
        )
      ],
      uniqueTogether: ['user_id', 'role_name'],
    );

    // Inicialización centralizada del ORM
    return await DatabaseManager().initialize(
      DatabaseConfig(
        dbName: 'app_database.db', 
        version: 6, // Incrementamos para agregar metadata a users
        password: 'secure_sqlcipher_key',
        tables: [
          userRolesSchema, 
          User.tableSchema, 
          Post.tableSchema, 
          Comment.tableSchema,
          Category.tableSchema,
          Product.tableSchema,
          Profile.tableSchema,
        ],
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 4) {
            await db.execute('ALTER TABLE posts ADD COLUMN is_active INTEGER DEFAULT 1');
          }
          if (oldVersion < 6) {
            // Aseguramos que 'metadata' exista en users si es una base de datos vieja
            try {
              await db.execute('ALTER TABLE users ADD COLUMN metadata TEXT');
            } catch (e) {
              print('ORM: Column metadata might already exist: $e');
            }
          }
        },
      )
    );
  }

  // Helpers para obtener Repositorios sin configurar nada en la UI
  Repository<User> get users => Repository<User>(User.tableSchema, User.fromMap);
  Repository<Post> get posts => Repository<Post>(Post.tableSchema, Post.fromMap);
  Repository<Category> get categories => Repository<Category>(Category.tableSchema, Category.fromMap);
  Repository<Product> get products => Repository<Product>(Product.tableSchema, Product.fromMap);
  Repository<Profile> get profiles => Repository<Profile>(Profile.tableSchema, Profile.fromMap);
}