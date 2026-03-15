import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/examples/example.dart';
import 'package:ui/orm/example/orm_demo_screen.dart';
import 'package:ui/routers/go.dart';
import 'package:ui/ui/theme.dart';
import 'package:ui/utils/files.dart';
import 'package:ui/utils/logs.dart';

import 'package:path_provider/path_provider.dart';
import 'package:ui/utils/permissions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Perm.getManageExternalStorage();

  Directory? directory;
  if (Platform.isAndroid) {
    directory = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    // En iOS usamos Documents para que sea visible en la app "Archivos"
    directory = await getApplicationDocumentsDirectory();
  }
  if (directory != null) {
    await lg.init(saveToFile: true, directory: directory);
  }

  // --- EJEMPLOS DE USO DE FILEMANAGER ---

  // 1. Obtener directorios básicos
  FileManager.getPublicDirectoryApp().then((value) {
    lg.s(msg: 'Public directory: $value', module: 'FILES');
  });

  FileManager.getPrivateDirectoryApp().then((value) {
    lg.s(msg: 'Private directory: $value', module: 'FILES');
  });

  FileManager.getCacheDirectoryApp().then((value) {
    lg.s(msg: 'Cache directory: $value', module: 'FILES');
  });

  FileManager.getExternalDirectory().then((value) {
    lg.s(msg: 'External (Persistent) directory: $value', module: 'FILES');
  });

  // 2. Crear una carpeta en un directorio específico
  FileManager.createFolder(
    typeDirectory: TypeDirectory.public,
    folder: 'Documentos_App',
  ).then((dir) {
    if (dir != null) {
      lg.s(msg: 'Carpeta creada: ${dir.path}', module: 'FILES');

      // 3. Guardar un archivo dentro de esa carpeta
      // Nota: Necesitas un objeto File de origen para saveFile según tu implementación actual
      // Para este ejemplo, supongamos que tenemos un archivo temporal
      final tempFile = File('${directory!.path}/temp.txt');
      tempFile.writeAsStringSync('Contenido de prueba');

      FileManager.saveFile(
        typeDirectory: TypeDirectory.public,
        folder: 'Documentos_App',
        fileName: 'mi_archivo.txt',
        file: tempFile,
      ).then((savedFile) {
        if (savedFile != null) {
          lg.s(msg: 'Archivo guardado: ${savedFile.path}', module: 'FILES');

          // 4. Verificar existencia de carpeta y archivo
          FileManager.existFolderDirectory(
            typeDirectory: TypeDirectory.public,
            folder: 'Documentos_App',
          ).then((exists) {
            lg.s(msg: '¿Existe la carpeta?: $exists', module: 'FILES');
          });

          FileManager.existFileDirectory(
            typeDirectory: TypeDirectory.public,
            folder: 'Documentos_App',
            fileName: 'mi_archivo.txt',
          ).then((exists) {
            lg.s(msg: '¿Existe el archivo?: $exists', module: 'FILES');
          });
        } else {
          lg.e(msg: 'No se pudo guardar el archivo', module: 'FILES');
        }
      });
    } else {
      lg.e(msg: 'No se pudo crear la carpeta', module: 'FILES');
    }
  });

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
    final result = await Go.to(route: Routes.example, args: {'id': 123});

    lg.s(msg: 'Usuario autenticado1', module: 'AUTH');
    lg.d(msg: 'Usuario autenticado2', module: 'AUTH');
    lg.i(msg: 'Usuario autenticado3', module: 'AUTH');
    lg.w(msg: 'Usuario autenticado4', module: 'AUTH');
    lg.e(msg: 'Usuario autenticado5', module: 'AUTH');
    lg.f(msg: 'Usuario autenticado6', module: 'AUTH');

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

            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const OrmDemoScreen())),
              icon: const Icon(Icons.storage),
              label: const Text('Ir a ORM Demo'),
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
