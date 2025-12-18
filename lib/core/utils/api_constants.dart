class ApiConstants {
  // Ajustar esta URL según el entorno (simulador Android usa 10.0.2.2)
  static const String baseUrl = 'http://localhost:8080';
  
  // Endpoints Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Endpoints User
  static const String userProfile = '/user/profile';
  
  // Endpoints Feed (Ejemplo, ajustar según controllers reales)
  static const String posts = '/content/post';
  static const String stories = '/content/stories';
}
