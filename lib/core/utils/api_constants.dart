import 'package:flutter/foundation.dart';

class ApiConstants {
  // URLs por entorno
  static const String _localUrl = 'http://localhost:8000';
  
  // URL de producción - usar IP del servidor
  static const String _prodUrl = String.fromEnvironment(
    'API_URL', 
    defaultValue: 'http://62.146.181.70'
  );

  // Selecciona automáticamente la URL según la plataforma
  // Web (local/debug) = localhost
  // Mobile (Android/iOS) = producción
  static String get baseUrl {
    if (kIsWeb) {
      // En web siempre usar localhost para desarrollo
      return _localUrl;
    } else {
      // En móvil usar producción
      return _prodUrl;
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
