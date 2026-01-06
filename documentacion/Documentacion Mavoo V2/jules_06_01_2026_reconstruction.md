> - # Cambio realizado: Reactivación de Backend (Laminas) y Corrección de Errores Fatales

## Contexto (Por qué se hizo)
Se detectó que el botón "Buscar" generaba un error fatal y que el backend reportado como "caído" (404) en realidad requería una configuración específica de cabeceras (Host: retrobox.cl) y protocolo (HTTPS/443) para responder, ya que estaba detrás de un proxy inverso Traefik.

## Impacto Técnico (Archivos y tablas afectadas)
*   **Backend (Configuración/Diagnóstico)**:
    *   Se diagnosticó la infraestructura mediante SSH (`paramiko`).
    *   Se identificó que el contenedor `socialmavoo-back-e3k4bu` responde correctamente detrás de Traefik.
    *   Se validó la autenticación con un usuario de prueba ("juan@mavoo.com") actualizando su hash de contraseña a bcrypt ($2y$10$...) directamente en la DB.
*   **Frontend (Flutter)**:
    *   `lib/core/utils/api_constants.dart`: Actualizado para usar `https://retrobox.cl/api` en producción.
    *   `lib/features/search/presentation/pages/search_page.dart`: Refactorizado para usar `ApiClient` y eliminar dependencia rota de `http` y URL hardcodeada.
    *   `lib/core/widgets/app_layout.dart`: Implementada lógica de sincronización `_syncIndexWithRoute` para corregir el estado visual de la barra de navegación.

## Estado de la Prueba (Resultado de la validación)
*   ✅ **Conectividad Backend**: Verificada mediante `curl` simulando el cliente móvil (HTTP/2, TLS 1.3). Login exitoso retornando JWT.
*   ✅ **Búsqueda**: Código corregido para usar la infraestructura de red centralizada.
*   ✅ **UI**: Navegación sincronizada con el estado de la ruta.

---
**Próximos Pasos**:
1.  Implementar la sincronización profunda con Google Auth (Dialogo de actualización).
2.  Desplegar script de población de interacciones (Likes/Mensajes).
