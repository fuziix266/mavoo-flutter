import 'package:flutter/foundation.dart';

class ApiConstants {
  // URLs por entorno
  static const String _localUrl = 'http://localhost/mavoo/mavoo_laminas/public';
  // Permite configurar la URL de producción al compilar con --dart-define=API_URL=...
  // Si no se define, usa el valor por defecto.
  static const String _prodUrl = String.fromEnvironment(
    'API_URL', 
    defaultValue: 'https://api.retrobox.cl'
  );

  // Selecciona automáticamente la URL según el modo (Debug = Local, Release = Prod)
  static String get baseUrl {
    if (kReleaseMode) {
      return _prodUrl;
    } else {
      // Por defecto en debug usamos local. 
      // Si quieres probar producción en local, cambia esto a return _prodUrl;
      return _localUrl;
    }
  }
  
  // Endpoints Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String socialLogin = '/auth/social-login';
  
  // Endpoints User
  static const String userProfile = '/user/profile';
  
  // Endpoints Feed (Ejemplo, ajustar según controllers reales)
  static const String posts = '/content/post';
  static const String stories = '/content/stories';
}
