import 'dart:developer' as developer;
import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart' show kDebugMode;

enum LogLevel { success, debug, info, warning, error, fatal }

class FastLogger {
  static final FastLogger _instance = FastLogger._internal();
  factory FastLogger() => _instance;

  FastLogger._internal();

  bool debugMode = kDebugMode;
  bool _saveToFile = false;
  File? _logFile;

  // Resource optimization constants
  static const int _maxFileSize = 5 * 1024 * 1024;
  static const int _maxQueueSize = 1000;

  final ListQueue<String> _writeQueue = ListQueue<String>();
  bool _isWriting = false;

  static const _reset = '\x1B[0m';
  static const _light = '\x1B[37m';
  static const _green = '\x1B[32m';
  static const _blue = '\x1B[34m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _fatal = '\x1B[38;2;139;69;19m';

  int get _consoleWidth {
    try {
      return stdout.terminalColumns;
    } catch (_) {
      return 100;
    }
  }

  Future<void> init({
    required Directory directory,
    bool saveToFile = false,
  }) async {
    _saveToFile = saveToFile;
    if (_saveToFile) {
      await _initLogFile(directory: directory);
    }
  }

  Future<void> _initLogFile({required Directory directory}) async {
    try {
      final logDir = Directory('${directory.path}/logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final now = DateTime.now();
      final d = now.day.toString().padLeft(2, '0');
      final m = now.month.toString().padLeft(2, '0');
      final y = now.year;
      final h = now.hour.toString().padLeft(2, '0');

      final fileName = 'log_D${d}_${m}_${y}___H$h.log';
      final path = '${logDir.path}/$fileName';
      _logFile = File(path);

      if (await _logFile!.exists()) {
        final size = await _logFile!.length();
        if (size > _maxFileSize) {
          final backupFile = File('${logDir.path}/$fileName.bak');
          await _logFile!.copy(backupFile.path);
          await _logFile!.writeAsString('');
        }
      }
    } catch (e) {
      // Silent on init errors
    }
  }

  void _log(
    LogLevel level,
    String message, [
    String? module,
    StackTrace? stack,
  ]) {
    final label = level.toString().split('.').last.toLowerCase();

    if (debugMode) {
      final color = _getColor(level);
      final moduleLabel = (module ?? label).toUpperCase();
      final dividerLength = _consoleWidth - moduleLabel.length - 2;
      final separatorLength = _consoleWidth - 2;

      final buffer = StringBuffer();

      buffer.write('$color[$moduleLabel]${'-' * dividerLength}\n$_reset');

      // Envolver el mensaje sin ninguna indentación inicial
      final maxWidth = _consoleWidth;
      final words = message.split(' ');
      final List<String> lines = [];
      String currentLine = '';

      for (var word in words) {
        final testLine = currentLine.isEmpty ? word : '$currentLine $word';
        if (testLine.length <= maxWidth) {
          currentLine = testLine;
        } else {
          lines.add(currentLine);
          currentLine = word;
        }
      }
      if (currentLine.isNotEmpty) {
        lines.add(currentLine);
      }

      // Escribir todas las líneas sin espacios al inicio
      for (var line in lines) {
        buffer.write('$color$line\n$_reset');
      }

      buffer.write('$color${'-' * separatorLength}\n$_reset');

      developer.log(
        buffer.toString(),
        level: _getDeveloperLevel(level),
        stackTrace: stack,
      );
    }

    if (_saveToFile && _logFile != null) {
      if (_writeQueue.length >= _maxQueueSize) {
        _writeQueue.removeFirst();
      }

      final timeStr = _getCurrentTime();
      final moduleStr = (module != null && module.isNotEmpty)
          ? '[$module]'
          : '[$label]';
      var logMessage = '$timeStr $moduleStr => $message\n';

      if (stack != null &&
          (level == LogLevel.error || level == LogLevel.fatal)) {
        final stackLines = stack.toString().split('\n').take(2).join(' | ');
        logMessage += '\n  Stack: $stackLines';
      }

      _writeQueue.add(logMessage);

      if (!_isWriting) {
        _scheduleWrite();
      }
    }
  }

  void _scheduleWrite() {
    _isWriting = true;
    scheduleMicrotask(_processWriteQueue);
  }

  Future<void> _processWriteQueue() async {
    if (_writeQueue.isEmpty || _logFile == null) {
      _isWriting = false;
      return;
    }

    try {
      final buffer = StringBuffer();
      while (_writeQueue.isNotEmpty) {
        buffer.writeln(_writeQueue.removeFirst());
      }
      await _logFile!.writeAsString(buffer.toString(), mode: FileMode.append);
    } catch (e) {
      // Silent on write errors
    } finally {
      if (_writeQueue.isNotEmpty) {
        _scheduleWrite();
      } else {
        _isWriting = false;
      }
    }
  }

  int _getDeveloperLevel(LogLevel level) {
    switch (level) {
      case LogLevel.success:
        return 0;
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
  }

  String _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.success:
        return _green;
      case LogLevel.debug:
        return _light;
      case LogLevel.info:
        return _blue;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
      case LogLevel.fatal:
        return _fatal;
    }
  }

  void s({String? module, required String msg}) =>
      _log(LogLevel.success, msg, module);
  void d({String? module, required String msg}) =>
      _log(LogLevel.debug, msg, module);
  void i({String? module, required String msg}) =>
      _log(LogLevel.info, msg, module);
  void w({String? module, required String msg}) =>
      _log(LogLevel.warning, msg, module);
  void e({String? module, required String msg, StackTrace? stack}) =>
      _log(LogLevel.error, msg, module, stack);
  void f({String? module, required String msg, StackTrace? stack}) =>
      _log(LogLevel.fatal, msg, module, stack);
}

final lg = FastLogger();
