import 'package:flutter/widgets.dart';
import '../core/database_config.dart';
import '../core/db_manager.dart';
import '../repository/repository.dart';
import 'user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Starting ORM Testing...');

  DatabaseManager().initialize(
    DatabaseConfig(
      dbName: 'test_orm.db', 
      version: 1, 
      password: 'my_super_secret_password',
      tables: [User.tableSchema],
    ),
  );

  await DatabaseManager().database;
  print('Database created with User tables auto-generated.');

  final userRepository = Repository<User>(User.tableSchema, User.fromMap);

  print('--- Insert Data ---');
  final user1Id = await userRepository.insert(User(name: 'Alice', age: 25));
  final user2Id = await userRepository.insert(User(name: 'Bob', age: 30, isActive: false));

  print('Inserted Alice with ID $user1Id');
  print('Inserted Bob with ID $user2Id');

  print('--- Query Data ---');
  final allUsers = await userRepository.findAll();
  print('All users: ${allUsers.map((u) => "${u.name} (age: ${u.age}, active: ${u.isActive})").toList()}');

  final count = await userRepository.count();
  print('Total users count: $count');

  print('--- Advanced Query Building ---');
  final activeQuery = await userRepository.query.where('is_active', 1).get();
  print('Raw active query results: $activeQuery');
  
  final getBob = await userRepository.query.where('name', 'Bob').first();
  print('First object matching name Bob: $getBob');

  final adults = await userRepository.query
      .whereRaw('age >= ? AND is_active = ?', [18, 1])
      .orderBy('age', descending: true)
      .limit(5)
      .get();
  print('Adults active (top 5): $adults');

  print('--- Update Data ---');
  final userToUpdate = allUsers.firstWhere((u) => u.name == 'Alice');
  final aliceModified = User(id: userToUpdate.id, name: 'Alice', age: 26, isActive: userToUpdate.isActive, createdAt: userToUpdate.createdAt);
  
  await userRepository.update(aliceModified);
  print('Updated Alice age to 26.');

  print('--- Post-Update Check ---');
  final updatedUsers = await userRepository.findAll();
  print('All users now: ${updatedUsers.map((u) => "${u.name} (age: ${u.age})").toList()}');

  print('--- Delete Operations ---');
  final userToDelete = updatedUsers.firstWhere((u) => u.name == 'Bob');
  await userRepository.delete(userToDelete.id);
  print('Deleted Bob.');

  final finalUsers = await userRepository.findAll();
  print('Final remaining users: ${finalUsers.map((u) => u.name).toList()}');

  print('--- Find helpers ---');
  final maybeAlice = await userRepository.findById(1);
  print('findById(1): $maybeAlice');

  final inactive = await userRepository.findWhere('is_active', 0);
  print('Inactive users: $inactive');
}
