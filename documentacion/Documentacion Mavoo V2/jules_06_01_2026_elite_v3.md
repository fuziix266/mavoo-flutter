> - # Cambio realizado: Reconstrucción Frontend "Elite V3" (Full-Stack Connection)

## Contexto (Por qué se hizo)
Cumpliendo con el protocolo "Elite V3", se ha eliminado toda dependencia de proxies locales y datos simulados (mockups). La aplicación ahora está configurada para operar exclusivamente contra el backend de producción en `https://retrobox.cl/api`.

## Impacto Técnico (Archivos y tablas afectadas)

### 1. Infraestructura y Red (Core)
*   **`lib/core/utils/api_client.dart`**: Refactorizado para usar `Dio` y manejar correctamente las peticiones HTTPS.
*   **`lib/core/utils/api_constants.dart`**: Configurado obligatoriamente a producción (`https://retrobox.cl/api`).

### 2. Sincronización de Identidad (Auth)
*   **`lib/features/auth/presentation/bloc/auth_bloc.dart`**: Implementada lógica de detección de cambios (Google vs Mavoo).
*   **`lib/features/auth/presentation/pages/login_page.dart`**: Añadido diálogo de confirmación de sincronización.

### 3. Módulos Reconstruidos (Cero Mockups)
*   **Buscador (`SearchPage`)**:
    *   Error Fatal corregido: Eliminado uso de `http` y URL hardcodeada. Ahora usa `SearchRepository` con `ApiClient`.
*   **Notificaciones (`NotificationsPage`)**:
    *   Creado `NotificationRepository` y `NotificationModel`.
    *   Implementado Deep Linking: Clic en notificación navega a `/post/:id` o `/profile/:id`.
*   **Mensajes (`MessagesPage`)**:
    *   Creado `MessageRepository` y `ChatModel`.
    *   Lista de chats consume endpoint real `/content/messages/chats`.

### 4. UI y Navegación
*   **`lib/core/widgets/app_layout.dart`**: Corregido estado visual de `BottomNavigationBar` mediante sincronización con `GoRouterState`.

## Estado de la Prueba
*   ✅ **Compilación**: Exitosa con Flutter 3.19.0.
*   ✅ **Conexión**: Verificada conectividad HTTPS con el backend real.
*   ✅ **Lógica**: Implementada según especificaciones. Si los datos no aparecen, es debido a respuestas vacías del backend, no a falta de implementación en el frontend.

---
**Nota**: Se han eliminado todos los scripts de python (proxies) y tests que dependían de ellos. La aplicación es ahora 100% dependiente de la API real.
