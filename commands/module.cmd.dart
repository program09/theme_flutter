import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print(
      'Uso: dart commands/module.cmd.dart /ruta/donde/crear <NombreModulo>',
    );
    print('Ejemplo: dart commands/module.cmd.dart modules/auth LoginModule');
    print(
      'Ejemplo: dart commands/module.cmd.dart modules/auth/login LoginModule',
    );
    print('');
    print('📌 El directorio se creará en minúsculas (snake_case)');
    print('📌 Los archivos usarán snake_case: mi_modulo.screen.dart');
    print('📌 Las clases usarán PascalCase: MiModuloScreen');
    return;
  }

  // Parsear argumentos
  String path = args[0];
  String moduleName = args.length > 1 ? args[1] : '';

  // Si no se proporcionó nombre de módulo, extraer del path
  if (moduleName.isEmpty) {
    final segments = path.split('/');
    moduleName = _toPascalCase(segments.last);
  }

  // Limpiar path (remover / inicial si existe)
  if (path.startsWith('/')) {
    path = path.substring(1);
  }

  // Asegurar que el path esté en minúsculas (snake_case)
  final pathSegments = path.split('/');
  final normalizedPath = pathSegments
      .map((segment) => _toSnakeCase(segment))
      .join('/');

  // El nombre del módulo para archivos (snake_case)
  final fileNameBase = _toSnakeCase(moduleName);

  // El nombre del módulo para clases (PascalCase)
  final classNameBase = _toPascalCase(moduleName);

  // Ruta base donde se crearán los archivos
  final targetDirStr = 'lib/$normalizedPath';
  final targetDir = Directory(targetDirStr);

  // Crear directorio si no existe
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }

  // Verificar si los archivos ya existen
  final screenFile = File('$targetDirStr/$fileNameBase.screen.dart');
  final controllerFile = File('$targetDirStr/$fileNameBase.controller.dart');
  final bindingFile = File('$targetDirStr/$fileNameBase.binding.dart');

  if (screenFile.existsSync() ||
      controllerFile.existsSync() ||
      bindingFile.existsSync()) {
    print(
      '⚠️  Algunos archivos ya existen. ¿Deseas sobrescribirlos?, Se eliminaran los archivos existentes (s/n)',
    );
    final response = stdin.readLineSync()?.toLowerCase();
    if (response != 's' && response != 'si') {
      print('❌ Operación cancelada');
      return;
    }
  }

  // Generar archivos
  print('\n✅ Generando módulo: $classNameBase');

  _createFile(screenFile, _screenTemplate(classNameBase, fileNameBase));
  _createFile(controllerFile, _controllerTemplate(classNameBase));
  _createFile(bindingFile, _bindingTemplate(classNameBase, fileNameBase));

  print('\n✅ Módulo "$classNameBase" generado con éxito en $targetDirStr');
  print('\n✅ Para usar este módulo, agrega en tus rutas:');
  print('''
    GetPage(
      name: '/${_toSnakeCase(classNameBase)}',
      page: () => ${classNameBase}Screen(),
      binding: ${classNameBase}Binding(),
    ),
  ''');
}

void _createFile(File file, String content) {
  if (file.existsSync()) {
    print('🔄 Sobrescribiendo: ${file.path}');
  } else {
    //print('✅ Creando: ${file.path}');
  }
  file.writeAsStringSync(content);
}

// Convierte a snake_case (ej: "MiModuleApp" -> "mi_module_app")
String _toSnakeCase(String input) {
  if (input.isEmpty) return input;

  // Si ya está en snake_case, devolver en minúsculas
  if (input.contains('_')) {
    return input.toLowerCase();
  }

  // Convertir PascalCase/camelCase a snake_case
  final buffer = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (char.toUpperCase() == char && char.toLowerCase() != char && i != 0) {
      buffer.write('_');
    }
    buffer.write(char.toLowerCase());
  }
  return buffer.toString();
}

// Convierte a PascalCase (ej: "mi_module_app" -> "MiModuleApp")
String _toPascalCase(String input) {
  if (input.isEmpty) return input;

  // Si está en snake_case, convertir a PascalCase
  if (input.contains('_')) {
    return input.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
  }

  // Si ya está en PascalCase o camelCase, asegurar primera letra mayúscula
  return input[0].toUpperCase() + input.substring(1);
}

String _screenTemplate(String className, String fileName) {
  // Generar el nombre de la ruta automáticamente
  // final routeName = _toSnakeCase(className);

  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '$fileName.controller.dart';

class ${className}Screen extends GetView<${className}Controller> {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '${className}Screen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
''';
}

String _controllerTemplate(String className) {
  return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${className}Controller extends GetxController {
  RxString title = ''.obs;
  RxString subtitle = ''.obs;
  RxBool isLoading = false.obs;
  late BuildContext context;
  
  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit code
    print('${className}Controller initialized');
  }

  @override
  void onReady() {
    super.onReady();
    context = Get.context!;
    // TODO: implement onReady code
    print('${className}Controller ready');
  }

  @override
  void onClose() {
    // TODO: clean controller
    super.onClose();
    print('${className}Controller closed');
  }
}
''';
}

String _bindingTemplate(String className, String fileName) {
  return '''
import 'package:get/get.dart';
import '$fileName.controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${className}Controller>(
      () => ${className}Controller(),
    );
  }
}
''';
}
