# 📄 Configuración de Persistencia de Logs y Base de Datos

Hemos configurado un sistema híbrido que prioriza la **privacidad de los datos** y la **facilidad de acceso a los logs** para depuración.

---

## 📂 Logs (Públicos y Accesibles)

Los logs están diseñados para ser visibles por el usuario, permitiendo su extracción para soporte técnico.

### Ubicación de Archivos
*   **Android**: Se guardan en el almacenamiento externo (`Android/data/[package.name]/files/logs/`).
*   **iOS**: Se guardan en la carpeta **Documents**, lo que los hace visibles en la aplicación nativa "Archivos".

### 🍏 Configuración Adicional para iOS
Para que la carpeta de la app aparezca en el iPhone, el archivo `ios/Runner/Info.plist` incluye estas claves:

```xml
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

---

## 🔒 Base de Datos (Privada y Segura)

A diferencia de los logs, la base de datos se almacena en una ubicación protegida que **no es visible** para el usuario ni para otras aplicaciones.

### Ubicación Técnica
*   **Android**: Carpeta interna de bases de datos del sistema (`databases/`).
*   **iOS**: Directorio `Application Support` o el estándar de `getDatabasesPath`.

> [!IMPORTANT]
> Aunque el intercambio de archivos esté activado para ver los logs, la base de datos **sigue protegida** ya que el sistema solo expone la carpeta `Documents`, dejando la carpeta de datos del sistema (donde está la BD) totalmente oculta.

---

## 🚀 Uso en Flutter (Main)

Recuerda inicializar los bindings antes de configurar el logger:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  runApp(const MainApp());
}
```
