import '../config/environment.dart';

class ApiConstants {
  // URL base dinámica según el entorno (desarrollo/producción)
  static String get baseUrl => Environment.apiBaseUrl;
  
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
