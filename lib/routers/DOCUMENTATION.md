# Sistema de Rutas (GetX)

Este proyecto utiliza **GetX** para el manejo de rutas, navegaciones y parámetros. A continuación se detalla cómo utilizar las herramientas disponibles.

## 1. Clases Principales

### `AppRouter`
Helper estático para todas las navegaciones.
- `to(route, {arguments, parameters})`: Navega a una nueva pantalla. Retorna un `Future` que se completa cuando se vuelve de la ruta.
- `off(route, {arguments, parameters})`: Navega y reemplaza la pantalla actual (quita la anterior del historial).
- `offAll(route, {arguments, parameters})`: Navega y limpia todo el historial de navegación.
- `back({result})`: Regresa a la pantalla anterior. Opcionalmente envía un `result`.

### `RouteArgs`
Helper para extraer datos enviados a una ruta.
- `argsAll`: Retorna todos los argumentos enviados como objeto/mapa.
- `paramsAll`: Retorna todos los parámetros de la URL (query params).
- `args(key)`: Extrae un valor específico del objeto `arguments`.
- `param(key)`: Extrae un valor específico de los parámetros de la URL.

### `AnimationRoutes`
Contiene todas las transiciones disponibles para las rutas (ej: `fadeIn`, `zoom`, `rightToLeft`, etc.).

---

## 2. Uso de Parámetros

### Enviar Parámetros
Puedes pasar datos mediante `arguments` (objetos complejos) o `parameters` (strings en la URL).

```dart
// En main.dart o cualquier vista
AppRouter.to(
  Routes.example, 
  arguments: {
    'id': 123, 
    'projectId': 'ABC'
  }
);
```

### Recibir Parámetros
En la pantalla destino, se recomienda capturar los parámetros en el constructor (inyectados desde `AppPages`) o directamente con `RouteArgs`.

```dart
// En example.dart
final id = RouteArgs.args('id'); // 123
final project = RouteArgs.args('projectId'); // 'ABC'
```

---

## 3. Ejemplo de Configuración de Páginas

Actualmente, las páginas se definen en `example.dart` dentro de la clase `AppPages`:

```dart
class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.example,
      page: () {
        // Ejemplo de inyección dinámica al constructor
        return Example(
          id: RouteArgs.args('id'),
          projectId: RouteArgs.args('projectId').toString(),
        );
      },
      transition: Transition.zoom,
    ),
  ];
}
```

---

## 4. Retornar Datos al Volver

Para ejecutar una acción al regresar de una ruta:

1. **Desde la pantalla de origen:**
```dart
final result = await AppRouter.to(Routes.example);
print(result); // Recibe el valor enviado desde .back()
```

2. **Desde la pantalla de destino:**
```dart
AppRouter.back(result: 'Operación Exitosa');
```
