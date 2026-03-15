# 📁 Guía de Gestión de Archivos (Files Utility)

La clase `Files` en `lib/utils/files.dart` proporciona una forma unificada y segura de interactuar con el sistema de archivos, diferenciando claramente entre almacenamiento **Público** (visible al usuario) y **Privado** (oculto).

---

## 🏗️ Estructura del Almacenamiento

### 1. Almacenamiento Público (Visible)
*   **Android**: Carpeta externa (`Android/data/.../files/`).
*   **iOS**: Carpeta `Documents` (Visible en la app "Archivos").
*   **Uso**: Ideal para logs, exportaciones de datos o archivos que el usuario debe poder ver y compartir.

### 2. Almacenamiento Privado (Oculto)
*   **Android/iOS**: Carpeta `Application Support`.
*   **Uso**: Ideal para configuraciones, bases de datos sensitivas o archivos internos que no deben ser manipulados por el usuario.

---

## 🚀 Ejemplos de Uso

### Obtener Directorios Base
```dart
Directory publicDir = await Files.getPublicDirectory();
Directory privateDir = await Files.getPrivateDirectory();
```

### Gestión de Carpetas
```dart
// Crear carpetas
Directory folder = await Files.createFolderPublic('mi_carpeta_publica');
Directory secureFolder = await Files.createFolderPrivate('mi_carpeta_secreta');

// Comprobar existencia
bool exists = await Files.existFolderPublic('mi_carpeta_publica');

// Eliminar carpetas (recursivo)
await Files.deleteFolderPublic('mi_carpeta_publica');
```

### Guardar Archivos
```dart
// Guardar un string como archivo
await Files.saveFilePublic('nota.txt', 'Hola mundo público');
await Files.saveFilePrivate('config.json', '{"theme": "dark"}');
```

---

## 🍏 Recordatorio para iOS
Para que el almacenamiento público sea visible en el iPhone, asegúrate de que el `Info.plist` tenga las claves de compartición activadas (ver [LOGS_SETUP.md](file:///Users/yordialcantarapaico/Develop/theme_flutter/lib/utils/LOGS_SETUP.md)).
