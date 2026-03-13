import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/examples/example.dart';
import 'package:ui/routers/go.dart';
import 'package:ui/ui/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: Routes.home,
      getPages: AppPages.pages,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _resultado;

  Future<void> _irAExample() async {
    // Pasamos parámetrosdinámicos a la ruta
    final result = await Go.to(Routes.example, args: {'id': 123});

    print(result);

    if (result != null) {
      setState(() => _resultado = result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch UI')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _irAExample,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Ir a Example'),
            ),

            // Muestra el resultado recibido al volver
            if (_resultado != null) ...[
              const SizedBox(height: 16),
              Text(
                'Resultado recibido:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_resultado!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
