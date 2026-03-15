import 'package:flutter/material.dart';
import 'package:ui/orm/repository/repository.dart';
import 'package:ui/orm/example/databa_helper.dart';
import 'package:ui/orm/example/seeder.dart';
import 'user.dart';
import 'post.dart';
import 'category.dart';
import 'product.dart';

class OrmDemoScreen extends StatefulWidget {
  const OrmDemoScreen({super.key});

  @override
  State<OrmDemoScreen> createState() => _OrmDemoScreenState();
}

class _OrmDemoScreenState extends State<OrmDemoScreen> {
  late Repository<User> userRepository;
  late Repository<Post> postRepository;
  late Repository<Category> categoryRepository;
  late Repository<Product> productRepository;

  List<User> users = [];
  List<Map<String, dynamic>> rawResults = [];
  bool isLoading = true;
  String currentView = 'Users'; // 'Users' | 'Joins' | 'Filters' | 'Raw'

  @override
  void initState() {
    super.initState();
    // Initialize repositories immediately to avoid LateInitializationError
    userRepository = DatabaseHelper().users;
    postRepository = DatabaseHelper().posts;
    categoryRepository = DatabaseHelper().categories;
    productRepository = DatabaseHelper().products;
    
    _loadData();
  }

  Future<void> _loadData() async {
    print('ORM Demo: Loading data...');
    try {
      setState(() => isLoading = true);
      final db = await DatabaseHelper().database;
      print('ORM Demo: Database initialized: ${db.path}');

      print('ORM Demo: Refreshing users...');
      await _refreshUsers();
      print('ORM Demo: Initial load complete.');
    } catch (e, stack) {
      print('ORM ERROR in _loadData: $e');
      print(stack);
      setState(() => isLoading = false);
    }
  }

  Future<void> _refreshUsers() async {
    print('ORM Demo: Refreshing users...');
    try {
      setState(() => isLoading = true);
      // EJEMPLO: Eager Loading de posts y perfil
      final query = userRepository.include(['posts', 'profile']);
      print('ORM Demo: Executing query with relations...');
      final allUsers = await userRepository.find(query);
      print('ORM Demo: Found ${allUsers.length} users.');
      
      setState(() {
        users = allUsers;
        currentView = 'Users';
        isLoading = false;
      });
    } catch (e) {
      print('ORM ERROR in _refreshUsers: $e');
      setState(() => isLoading = false);
    }
  }

  // --- Operaciones CRUD Practicas ---

  Future<void> _runSeeder() async {
    setState(() => isLoading = true);
    await DatabaseSeed.run();
    await _refreshUsers();
    _showSnackBar('¡Base de datos populada!');
  }

  Future<void> _clearAll() async {
    setState(() => isLoading = true);
    await userRepository.deleteAll();
    await postRepository.deleteAll();
    await categoryRepository.deleteAll();
    await productRepository.deleteAll();
    await _refreshUsers();
    _showSnackBar('¡Datos borrados!');
  }

  // --- Ejemplos de Consultas Reales ---

  Future<void> _testComplexJoin() async {
    setState(() => isLoading = true);
    // EJEMPLO: Join entre Productos y Categorías filtrando por precio
    final results = await productRepository.query
        .select([
          'products.name',
          'products.price',
          'categories.name as cat_name',
        ])
        .addSelect(
          'CASE WHEN products.price > 200 THEN "Expensive" ELSE "Cheap" END as price_category',
        )
        .innerJoin('categories', 'categories.id = products.category_id')
        .where('products.price', 100, operator: '>')
        .orderBy('products.price', descending: true)
        .get();

    setState(() {
      rawResults = results;
      currentView = 'Joins';
      isLoading = false;
    });
  }

  Future<void> _testFilters() async {
    setState(() => isLoading = true);
    // EJEMPLO: Combinación de WHERE, AND WHERE, OR WHERE y LIKE
    final filtered = await userRepository.query
        .where('age', 20, operator: '>')
        .andWhere('name LIKE ?', ['%Alice%'])
        .orWhere('is_active = ?', [1])
        .get();

    setState(() {
      rawResults = filtered;
      currentView = 'Filters';
      isLoading = false;
    });
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORM SQLCipher Tester'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _runSeeder,
            tooltip: 'Seed',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAll,
            tooltip: 'Clear',
          ),
        ],
      ),
      body: Column(
        children: [
          IgnorePointer(
            ignoring: isLoading,
            child: Opacity(
              opacity: isLoading ? 0.5 : 1.0,
              child: _buildToolBar(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      color: Colors.grey[100],
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _navButton('Usuarios', 'Users', _refreshUsers, Icons.people),
          _navButton('Joins', 'Joins', _testComplexJoin, Icons.link),
          _navButton('Filtros', 'Filters', _testFilters, Icons.filter_alt),
          _navButton('RAW SQL', 'Raw', () async {
            final raw = await userRepository.query.raw(
              'SELECT name, age FROM users LIMIT 5',
            );
            setState(() {
              rawResults = raw;
              currentView = 'Raw';
            });
          }, Icons.code),
          _navButton('Rel-Advanced', 'Rel-Adv', () async {
            setState(() => isLoading = true);
            // EJEMPLO: Eager Loading con filtrado y selección de columnas personalizada
            final results = await userRepository.include({
              'posts': (q) => q.select(['title', 'user_id']).limit(1), // Solo un post y solo estos campos
              'profile': (q) => q.select(['bio', 'userId']),
            }).findAll();
            
            setState(() {
              rawResults = results.map((u) => {
                'user': u.name,
                'posts_count': u.posts?.length ?? 0,
                'first_post': u.posts?.isNotEmpty == true ? u.posts!.first.title : 'N/A',
                'bio': u.profile?.bio ?? 'N/A',
              }).toList();
              currentView = 'Rel-Adv';
              isLoading = false;
            });
          }, Icons.settings_input_component),
          _navButton('Posts + User', 'Rel-Posts', () async {
            setState(() => isLoading = true);
            // EJEMPLO: Carga inversa (Post -> User)
            final results = await postRepository.include(['user']).findAll();
            setState(() {
              rawResults = results
                  .map(
                    (p) => {
                      'title': p.title,
                      'author': p.user?.name ?? 'Unknown',
                    },
                  )
                  .toList();
              currentView = 'Rel-Posts';
              isLoading = false;
            });
          }, Icons.account_tree),
        ],
      ),
    );
  }

  Widget _navButton(
    String label,
    String view,
    VoidCallback action,
    IconData icon,
  ) {
    final active = currentView == view;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        avatar: Icon(
          icon,
          size: 16,
          color: active ? Colors.white : Colors.indigo,
        ),
        label: Text(label),
        backgroundColor: active ? Colors.indigo : Colors.white,
        labelStyle: TextStyle(color: active ? Colors.white : Colors.indigo),
        onPressed: action,
      ),
    );
  }

  Widget _buildMainContent() {
    if (currentView == 'Users') {
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, i) {
          final u = users[i];
          return ListTile(
            title: Text('${u.name} (ID: ${u.id})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: ${u.age} | Profile: ${u.profile?.bio ?? "No Bio"}'),
                Text(
                  'Posts: ${u.posts?.length ?? 0} count',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updated = User(
                  id: u.id,
                  name: '${u.name} (Mod)',
                  age: u.age + 1,
                  metadata: u.metadata,
                );
                await userRepository.update(
                  updated,
                  fields: ['name', 'age'],
                ); // Partial Update
                _refreshUsers();
              },
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: rawResults.length,
      itemBuilder: (ctx, i) {
        final row = rawResults[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(row.values.first?.toString() ?? 'N/A'),
            subtitle: Text(row.toString()),
          ),
        );
      },
    );
  }
}
