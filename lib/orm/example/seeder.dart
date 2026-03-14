import 'package:ui/orm/example/databa_helper.dart';
import 'package:ui/orm/example/user.dart';
import 'package:ui/orm/example/category.dart';
import 'package:ui/orm/example/product.dart';
import 'package:ui/orm/example/post.dart';
import 'package:ui/orm/example/profile.dart';

class DatabaseSeed {
  static Future<void> run() async {
    final helper = DatabaseHelper();
    
    // 1. Ensure DB is ready
    await helper.database;

    // 2. Seed Categories
    print('ORM: Seeding categories...');
    final catElectronics = Category(name: 'Electronics', description: 'Gadgets and stuff');
    final catFashion = Category(name: 'Fashion', description: 'Clothing and accessories');
    
    await helper.categories.insert(catElectronics);
    await helper.categories.insert(catFashion);
    
    final allCats = await helper.categories.findAll();
    final electronicsId = allCats.firstWhere((c) => c.name.contains('Electronics')).id!;
    final fashionId = allCats.firstWhere((c) => c.name.contains('Fashion')).id!;

    // 3. Seed Products
    print('ORM: Seeding products...');
    await helper.products.insert(Product(
      name: 'Smartphone X',
      price: 999.99,
      categoryId: electronicsId,
      metadata: {'brand': 'Apple', 'model': 'X', 'specs': {'ram': '8GB', 'storage': '256GB'}},
    ));
    
    await helper.products.insert(Product(
      name: 'Leather Jacket',
      price: 199.50,
      categoryId: fashionId,
      metadata: {'material': 'Leather', 'color': 'Black', 'size': 'L'},
    ));

    // 4. Seed Users
    print('ORM: Seeding users...');
    final userAlice = User(
      name: 'Alice Smith',
      age: 28,
      metadata: {'role': 'admin', 'preferences': {'theme': 'dark'}},
    );
    final userBob = User(
      name: 'Bob Jones',
      age: 34,
      metadata: {'role': 'user', 'preferences': {'theme': 'light'}},
    );

    await helper.users.insert(userAlice);
    await helper.users.insert(userBob);
    
    final allUsers = await helper.users.findAll();
    final aliceId = allUsers.firstWhere((u) => u.name.contains('Alice Smith')).id!;
    final bobId = allUsers.firstWhere((u) => u.name.contains('Bob Jones')).id!;

    // 5. Seed Profiles
    print('ORM: Seeding profiles...');
    await helper.profiles.insert(Profile(
      userId: aliceId,
      bio: 'Loves technology and design.',
      location: 'POINT(-74.0060 40.7128)',
    ));
    
    await helper.profiles.insert(Profile(
      userId: bobId,
      bio: 'Coffee lover.',
      location: 'POINT(2.3522 48.8566)',
    ));

    print('ORM: Seeding completed successfully!');
  }
}
