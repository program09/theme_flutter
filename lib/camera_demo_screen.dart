import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/utils/files.dart';
import 'package:ui/utils/logs.dart';

class CameraDemoScreen extends StatefulWidget {
  const CameraDemoScreen({super.key});

  @override
  State<CameraDemoScreen> createState() => _CameraDemoScreenState();
}

class _CameraDemoScreenState extends State<CameraDemoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;
  String _statusText = '';
  bool _isEncrypted = false;

  static const String _appKey = 'clave_secreta_de_32_caract_!!_123';
  static const String _appIv = 'iv_personal_16_!!';

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true;
      _statusText = source == ImageSource.camera
          ? 'Abriendo cámara...'
          : 'Abriendo galería...';
    });

    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() => _statusText = 'Guardando archivo...');

        final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await FileManager.saveFile(
          typeDirectory: TypeDirectory.external,
          folder: '',
          fileName: fileName,
          file: File(photo.path),
        );

        if (savedFile != null) {
          setState(() {
            _image = savedFile;
            _isEncrypted = false;
          });
          lg.s(msg: 'Imagen lista: ${savedFile.path}', module: 'CAMERA');
        }
      }
    } catch (e) {
      lg.e(msg: 'Error: $e', module: 'CAMERA');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _encryptCurrent() async {
    if (_image == null || _isEncrypted) return;

    setState(() {
      _isLoading = true;
      _statusText = 'Encriptando...';
    });

    try {
      final encrypted = await FileManager.encryptFile(
        file: _image!,
        key: _appKey,
        iv: _appIv,
      );

      if (encrypted != null) {
        setState(() {
          _isEncrypted = true;
          _image = encrypted;
        });
        lg.s(msg: 'Archivo encriptado con éxito', module: 'CAMERA');
      }
    } catch (e) {
      lg.e(msg: 'Error encriptando: $e', module: 'CAMERA');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _decryptCurrent() async {
    if (_image == null || !_isEncrypted) return;

    setState(() {
      _isLoading = true;
      _statusText = 'Desencriptando...';
    });

    try {
      final decrypted = await FileManager.decryptFile(
        file: _image!,
        key: _appKey,
        iv: _appIv,
      );

      if (decrypted != null) {
        setState(() {
          _isEncrypted = false;
          _image = decrypted;
        });
        lg.s(msg: 'Archivo desencriptado con éxito', module: 'CAMERA');
      }
    } catch (e) {
      lg.e(msg: 'Error desencriptando: $e', module: 'CAMERA');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Security Demo')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: _image == null
                        ? const Text('No hay imagen seleccionada')
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isEncrypted
                                    ? 'ARCHIVO ENCRIPTADO (Binario)'
                                    : 'ARCHIVO DESENCRIPTADO (Imagen)',
                                style: TextStyle(
                                  color: _isEncrypted
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (!_isEncrypted)
                                Expanded(
                                  child: Image.file(
                                    _image!,
                                    key: ValueKey(
                                      _image!.path + _isEncrypted.toString(),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 200,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.lock,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text(
                                'Ruta: ${_image!.path}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icons.camera_alt,
                      label: 'Cámara',
                    ),
                    _ActionButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icons.photo_library,
                      label: 'Galería',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      onPressed: _image != null && !_isEncrypted
                          ? _encryptCurrent
                          : null,
                      icon: Icons.enhanced_encryption,
                      label: 'Encriptar',
                      color: Colors.blue,
                    ),
                    _ActionButton(
                      onPressed: _image != null && _isEncrypted
                          ? _decryptCurrent
                          : null,
                      icon: Icons.no_encryption,
                      label: 'Desencriptar',
                      color: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_isLoading) _LoadingOverlay(text: _statusText),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color? color;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  final String text;
  const _LoadingOverlay({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
