import 'package:get/get.dart';

// ─────────────────────────────────────────
//  Helper para navegar con la animación activa
// ─────────────────────────────────────────
class Go {
  Go._();

  // Ir a nueva ruta
  // arguments: datos que se envian a la nueva ruta
  // parameters: query params para la URL
  static Future<dynamic> to(
    String route, {
    dynamic args,
    Map<String, String>? params,
  }) =>
      Get.toNamed(route, arguments: args, parameters: params) ??
      Future.value(null);

  // Ir a nueva ruta y cerrar la anterior
  static void off(
    String route, {
    dynamic args,
    Map<String, String>? params,
  }) => Get.offNamed(route, arguments: args, parameters: params);

  // Ir a nueva ruta y cerrar todas las anteriores
  static void offAll(
    String route, {
    dynamic args,
    Map<String, String>? params,
  }) => Get.offAllNamed(route, arguments: args, parameters: params);

  // Regresar a la pantalla anterior
  static void back({dynamic result}) => Get.back(result: result);
}

// ─────────────────────────────────────────
//  Transiciones
// ─────────────────────────────────────────
class GoAnimation {
  GoAnimation._();
  static const Transition fadeIn = Transition.fadeIn;
  static const Transition fade = Transition.fade; // fade desde abajo
  static const Transition fadeOut = Transition.circularReveal;
  static const Transition downToUp = Transition.downToUp; // Desde abajo
  static const Transition leftToRight =
      Transition.leftToRight; // desde la izquierda
  static const Transition leftToRightWithFade =
      Transition.leftToRightWithFade; // desde la izquierda con fade
  static const Transition native = Transition.native; // Derecha a izquierda
  static const Transition noTransition = Transition.noTransition;
  static const Transition rightToLeft =
      Transition.rightToLeft; // desde la derecha
  static const Transition rightToLeftWithFade =
      Transition.rightToLeftWithFade; // desde la derecha con fade
  static const Transition size =
      Transition.size; // desde el medio hacia arriba y abajo
  static const Transition topLevel = Transition.topLevel; //
  static const Transition upToDown =
      Transition.upToDown; // desde arriba hacia abajo
  static const Transition zoom = Transition.zoom; // zoom desde el medio
}

// ─────────────────────────────────────────
//  Argumentos
// ─────────────────────────────────────────
class GoArgs {
  GoArgs._();
  static dynamic get argsAll => Get.arguments;
  static dynamic args(String key) => Get.arguments[key];
}

// ─────────────────────────────────────────
//  Parámetros
// ─────────────────────────────────────────
class GoParams {
  GoParams._();
  static Map<String, String?> get paramsAll => Get.parameters;
  static String? param(String key) => Get.parameters[key];
}
