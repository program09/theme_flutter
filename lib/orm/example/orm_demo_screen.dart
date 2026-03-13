import 'package:flutter/material.dart';
import 'package:ui/orm/core/database_config.dart';
import 'package:ui/orm/core/db_manager.dart';
import 'package:ui/orm/repository/repository.dart';
import 'user.dart';

class OrmDemoScreen extends StatefulWidget {
  const OrmDemoScreen({super.key});

  @override
  State<OrmDemoScreen> createState() => _OrmDemoScreenState();
}

class _OrmDemoScreenState extends State<OrmDemoScreen> {
  late Repository<User> userRepository;
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initOrm();
  }

  Future<void> _initOrm() async {
    // 1. Initialize the ORM DatabaseManager
    DatabaseManager().initialize(
      const DatabaseConfig(
        dbName: 'app_database.db', 
        version: 1, 
        password: 'secure_sqlcipher_key'
      ),
      [User(name: '', age: 0)], // Register Models for auto-creation
    );

    // 2. Ensuring the database exists
    await DatabaseManager().database;

    // 3. Create the Repository instance for User
    userRepository = Repository<User>(User(name: '', age: 0).tableSchema, User.fromMap);

    await _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    final allUsers = await userRepository.findAll();
    setState(() {
      users = allUsers;
      isLoading = false;
    });
  }

  Future<void> _addUser() async {
    final newUser = User(
      name: 'User ${DateTime.now().second}', 
      age: 20 + (DateTime.now().second % 30),
    );
    await userRepository.insert(newUser);
    await _loadUsers();
  }

  Future<void> _updateUser(User user) async {
    // Create new modified instance
    final modifiedUser = User(
      id: user.id,
      name: '${user.name} (Updated)',
      age: user.age + 1,
      isActive: !user.isActive,
      createdAt: user.createdAt,
    );
    await userRepository.update(modifiedUser);
    await _loadUsers();
  }

  Future<void> _deleteUser(User user) async {
    await userRepository.delete(user);
    await _loadUsers();
  }

  Future<void> _filterActive() async {
    setState(() => isLoading = true);
    // Fluent Query Builder
    final activeUsersMapList = await userRepository.query.where('is_active', 1).get();
    
    // Map raw query results manually, or create a mapper method.
    // In a real app the repo would expose `findWhere()` etc. 
    // We parse it manually using the fromMap here to demonstrate the query output.
    setState(() {
      users = activeUsersMapList.map((map) => User.fromMap(map)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORM SQLCipher Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _filterActive,
            tooltip: 'Filter Active',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
            tooltip: 'Load All',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age: ${user.age} | Active: ${user.isActive}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _updateUser(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}
