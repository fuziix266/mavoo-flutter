class Environment {
  // Detecta automáticamente el entorno basado en la URL actual
  static String get apiBaseUrl {
    // En producción (Dokploy), usa la URL de producción
    const String productionUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://mavoo-backend-pttow9-fa365c-62-146-181-70.traefik.me',
    );
    
    // En desarrollo local
    const String developmentUrl = 'http://localhost/mavoo/mavoo_laminas/public';
    
    // Detecta si estamos en producción o desarrollo
    if (const bool.fromEnvironment('dart.vm.product')) {
      // Modo release (producción)
      return productionUrl;
    } else {
      // Modo debug (desarrollo)
      return developmentUrl;
    }
  }
  
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;
}
