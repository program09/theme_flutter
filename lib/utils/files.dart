import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

enum TypeDirectory { external, public, private, cache }

class FileManager {
  static const String _appName = 'appname';

  // Helper to ensure a directory exists
  static Future<Directory> getOrCreate(Directory dir) async {
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // Internal helper to get app-specific directories
  static Future<Directory?> getAppDir({
    required TypeDirectory typeDirectory,
  }) async {
    Directory? base;

    switch (typeDirectory) {
      case TypeDirectory.external:
        if (Platform.isAndroid) {
          final extDir = await getExternalStorageDirectory();
          if (extDir == null) return null;
          final path = extDir.path;
          final index = path.indexOf("/Android/data/");
          base = (index != -1) ? Directory(path.substring(0, index)) : extDir;
        }
        break;
      case TypeDirectory.public:
        if (Platform.isAndroid) {
          base = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          base = await getApplicationDocumentsDirectory();
        }
        break;
      case TypeDirectory.private:
        if (Platform.isAndroid) {
          base = await getApplicationDocumentsDirectory();
        } else if (Platform.isIOS) {
          base = await getApplicationSupportDirectory();
        }
        break;
      case TypeDirectory.cache:
        base = await getTemporaryDirectory();
        return base; // No suffix for cache
    }

    if (base != null) {
      return await getOrCreate(Directory(join(base.path, _appName)));
    }
    return null;
  }

  // get persistent directory (survives uninstall on Android)
  static Future<Directory?> getExternalDirectory() =>
      getAppDir(typeDirectory: TypeDirectory.external);

  // get public storage directory
  static Future<Directory?> getPublicDirectoryApp() =>
      getAppDir(typeDirectory: TypeDirectory.public);

  // get private storage directory
  static Future<Directory?> getPrivateDirectoryApp() =>
      getAppDir(typeDirectory: TypeDirectory.private);

  // cache
  static Future<Directory?> getCacheDirectoryApp() =>
      getAppDir(typeDirectory: TypeDirectory.cache);

  static Future<Directory?> createFolder({
    required TypeDirectory typeDirectory,
    required String folder,
  }) async {
    final directory = await getAppDir(typeDirectory: typeDirectory);
    if (directory == null) return null;
    return await getOrCreate(Directory(join(directory.path, folder)));
  }

  static Future<File?> saveFile({
    required TypeDirectory typeDirectory,
    required String folder,
    required String fileName,
    required File file,
  }) async {
    try {
      final directory = await getAppDir(typeDirectory: typeDirectory);
      if (directory == null) {
        return null;
      }

      // Ensure the sub-folder exists
      final folderDir = Directory(join(directory.path, folder));
      await getOrCreate(folderDir);

      final targetFile = File(join(folderDir.path, fileName));

      // Read bytes from the SOURCE file and write to the TARGET file
      await targetFile.writeAsBytes(await file.readAsBytes());
      return targetFile;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> existFolderDirectory({
    required TypeDirectory typeDirectory,
    required String folder,
  }) async {
    final directory = await getAppDir(typeDirectory: typeDirectory);
    if (directory == null) return false;
    return await Directory(join(directory.path, folder)).exists();
  }

  static Future<void> deleteFolderDirectory({
    required TypeDirectory typeDirectory,
    required String folder,
  }) async {
    final directory = await getAppDir(typeDirectory: typeDirectory);
    if (directory == null) return;
    final folderPath = Directory(join(directory.path, folder));
    if (await folderPath.exists()) {
      await folderPath.delete(recursive: true);
    }
  }

  static Future<bool> existFileDirectory({
    required TypeDirectory typeDirectory,
    required String folder,
    required String fileName,
  }) async {
    final directory = await getAppDir(typeDirectory: typeDirectory);
    if (directory == null) return false;
    return await File(join(directory.path, folder, fileName)).exists();
  }

  static Future<bool> existFilePath({required String path}) async {
    return await File(path).exists();
  }

  static Future<File?> getFileDirectory({
    required TypeDirectory typeDirectory,
    required String folder,
    required String fileName,
  }) async {
    final directory = await getAppDir(typeDirectory: typeDirectory);
    if (directory == null) return null;
    return File(join(directory.path, folder, fileName));
  }

  static Future<File?> getFile({required String path}) async {
    return File(path);
  }
}
