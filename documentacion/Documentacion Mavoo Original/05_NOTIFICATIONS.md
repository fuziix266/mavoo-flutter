# Análisis Sección Notifications (Original)

## Descripción General

La sección de Notificaciones mantiene al usuario informado sobre interacciones relevantes: nuevos seguidores, likes, comentarios y etiquetas en sus publicaciones.

**Ubicación Frontend:** `documentacion/front_original/src/app/Notification/Notification.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/UserController.php` (función `user_notification_list`).

## Estructura Visual (Frontend)

El componente `Notification.tsx` organiza las alertas cronológicamente:

1.  **Agrupación:** Usa una utilidad `groupNotifications` para separar por "Today" (Hoy), "Yesterday" (Ayer) y fechas anteriores.
2.  **Tipos de Notificación:**
    - **Follow:** Muestra avatar del usuario y botón/texto.
    - **Post/Reel (Like, Comment, Tag):** Muestra miniatura del contenido (imagen o thumbnail de video).
3.  **Navegación:**
    - Clic en usuario -> Perfil.
    - Clic en miniatura Post -> Modal `PostDetail`.
    - Clic en miniatura Reel -> Modal `ReelComment`.

## Lógica del Backend (API)

### Listar Notificaciones

- **Endpoint:** `POST /api/user_notification_list`
- **Controlador:** `UserController::user_notification_list`
- **Funcionalidad:**
  - Marca automáticamente todas las notificaciones pendientes como **leídas** (`read_status = 1`).
  - Retorna lista ordenada descendentemente por ID.
  - Enriquece cada notificación con datos del usuario origen (avatar, nombre) y detale del contenido multimedia (`PostImages`/`PostVideos`) si corresponde.

### Tipos de Notificaciones (Backend Enum/Strings)

- `follow_user`
- `comment_post`, `comment_reel`
- `like_post`, `like_reel`
- `subcomment_post`, `subcomment_reel` (respuestas a comentarios)
- `tag_post`

## Comportamiento Esperado (Mavoo Flutter)

1.  **Badge de No Leídos:** Mostrar indicador numérico en el icono de notificaciones.
2.  **Tiempo Real:** Idealmente actualizar lista con WebSockets o polling (SocketController existente en backend sugiere soporte socket).
3.  **Interactividad:** Permitir seguir/dejar de seguir directamente desde la notificación si es tipo "follow".
