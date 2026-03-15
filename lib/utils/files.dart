import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Files {
  // get public storage directory
  static Future<Directory?> getPublicDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      return dir;
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  // get private storage directory
  static Future<Directory?> getPrivateDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      return dir;
    } else if (Platform.isIOS) {
      return await getApplicationSupportDirectory();
    }
    return null;
  }

  // Create folder in private storage
  static Future<Directory?> createFolderPrivate(String folderName) async {
    final base = await getPrivateDirectory();
    if (base == null) {
      return null;
    }
    final folder = Directory(join(base.path, folderName));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  // Create folder in public storage
  static Future<Directory?> createFolderPublic(String folderName) async {
    final base = await getPublicDirectory();
    if (base == null) {
      return null;
    }
    final folder = Directory(join(base.path, folderName));
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  // exist folder in private storage
  static Future<bool> existFolderPrivate(String folderName) async {
    final base = await getPrivateDirectory();
    if (base == null) {
      return false;
    }
    return await Directory(join(base.path, folderName)).exists();
  }

  // exist folder in public storage
  static Future<bool> existFolderPublic(String folderName) async {
    final base = await getPublicDirectory();
    if (base == null) {
      return false;
    }
    return await Directory(join(base.path, folderName)).exists();
  }

  // delete folder in private storage
  static Future<void> deleteFolderPrivate(String folderName) async {
    final base = await getPrivateDirectory();
    if (base == null) {
      return;
    }
    final folder = Directory(join(base.path, folderName));
    if (await folder.exists()) {
      await folder.delete(recursive: true);
    }
  }

  // delete folder in public storage
  static Future<void> deleteFolderPublic(String folderName) async {
    final base = await getPublicDirectory();
    if (base == null) {
      return;
    }
    final folder = Directory(join(base.path, folderName));
    if (await folder.exists()) {
      await folder.delete(recursive: true);
    }
  }

  // save file in private storage
  static Future<File?> saveFilePrivate(String fileName, String content) async {
    final base = await getPrivateDirectory();
    if (base == null) {
      return null;
    }
    final file = File(join(base.path, fileName));
    return await file.writeAsString(content);
  }

  // save file in public storage
  static Future<File?> saveFilePublic(String fileName, String content) async {
    final base = await getPublicDirectory();
    if (base == null) {
      return null;
    }
    final file = File(join(base.path, fileName));
    return await file.writeAsString(content);
  }

  // cache
  static Future<Directory?> getCacheDirectory() async {
    return await getTemporaryDirectory();
  }

  // save file in cache
  static Future<File?> saveFileCache(String fileName, String content) async {
    final base = await getCacheDirectory();
    if (base == null) {
      return null;
    }
    final file = File(join(base.path, fileName));
    return await file.writeAsString(content);
  }
}
