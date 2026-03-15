import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';

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
        } else if (Platform.isIOS) {
          base = await getApplicationDocumentsDirectory();
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

  // --- Encryption / Decryption ---

  static Future<File?> encryptFile({
    required File file,
    required String key,
    required String iv,
  }) async {
    try {
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();

      final encryptedBytes = await compute(
        _processCipher,
        _CipherData(bytes: bytes, key: key, iv: iv, isEncrypt: true),
      );

      return await file.writeAsBytes(encryptedBytes);
    } catch (e) {
      return null;
    }
  }

  static Future<File?> decryptFile({
    required File file,
    required String key,
    required String iv,
  }) async {
    try {
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();

      final decryptedBytes = await compute(
        _processCipher,
        _CipherData(bytes: bytes, key: key, iv: iv, isEncrypt: false),
      );

      return await file.writeAsBytes(decryptedBytes);
    } catch (e) {
      return null;
    }
  }
}

// Helper class for Isolate communication
class _CipherData {
  final Uint8List bytes;
  final String key;
  final String iv;
  final bool isEncrypt;

  _CipherData({
    required this.bytes,
    required this.key,
    required this.iv,
    required this.isEncrypt,
  });
}

// Background processing for encryption/decryption
List<int> _processCipher(_CipherData data) {
  // AES-256 requires 32 chars key
  final key = enc.Key.fromUtf8(data.key.padRight(32).substring(0, 32));
  final iv = enc.IV.fromUtf8(data.iv.padRight(16).substring(0, 16));
  final encrypter = enc.Encrypter(enc.AES(key));

  if (data.isEncrypt) {
    return encrypter.encryptBytes(data.bytes, iv: iv).bytes;
  } else {
    return encrypter.decryptBytes(enc.Encrypted(data.bytes), iv: iv);
  }
}
