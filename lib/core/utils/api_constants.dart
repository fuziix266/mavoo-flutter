class ApiConstants {
  // Ajustar esta URL según el entorno (simulador Android usa 10.0.2.2)
  static const String baseUrl = 'http://localhost/mavoo/mavoo_laminas/public';
  
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
