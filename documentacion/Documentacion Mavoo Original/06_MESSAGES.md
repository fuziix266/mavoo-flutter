# Análisis Sección Messages (Original)

## Descripción General

El módulo de Mensajes (Chat) permite la comunicación privada entre usuarios en tiempo real (o casi real). Soporta texto, imágenes, videos y compartir contenido de la plataforma (Posts, Stories).

**Ubicación Frontend:** `documentacion/front_original/src/app/Message/` (Varios componentes: `AllUserChatList`, `MessageSection`, `SendMessage`, etc.)
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/ChatController.php`

## Estructura Visual (Frontend)

El chat sigue un diseño estándar de dos paneles (en escritorio) o navegación por pantallas (móvil):

1.  **Lista de Conversaciones (`AllUserChatList.tsx`):**
    - Muestra usuarios con los que se ha interactuado.
    - Muestra el último mensaje, hora y contador de no leídos.
    - Muestra estado "Last seen" o "Online" (basado en `updated_at` del usuario).
2.  **Ventana de Chat (`MessageSection.tsx` / `MessageList.tsx`):**
    - Historial de mensajes ordenado cronológicamente.
    - Burbujas de mensaje diferenciadas por `type` (texto, imagen, post, story).
3.  **Input de Mensaje (`SendMessage.tsx`):**
    - Campo de texto.
    - Botón para adjuntar archivos (Imágenes/Videos).

## Lógica del Backend (API)

### Endpoints Principales

#### 1. Listar Conversaciones

- **Endpoint:** `POST /api/user_chat_list` (o `chat_list`)
- **Controlador:** `ChatController::user_chat_list`
- **Lógica:**
  - Identifica usuarios únicos con los que el usuario autenticado tiene mensajes (enviados o recibidos).
  - Obtiene el último mensaje de cada par.
  - Calcula mensajes no leídos (`read_message = 0`).
  - Retorna ordenado por fecha de último mensaje descendente.

#### 2. Obtener Mensajes de una Conversación

- **Endpoint:** `POST /api/message_list`
- **Controlador:** `ChatController::message_list`
- **Payload:** `to_user` (ID del otro usuario).
- **Lógica:**
  - Marca mensajes como leídos (`update read_message = 1`).
  - Obtiene conversación bidireccional.
  - Enriquece mensajes especiales (Posts/Reels/Stories compartidos) con sus thumbnails y datos actuales.

#### 3. Enviar Mensaje

- **Endpoint:** `POST /api/chat_api`
- **Controlador:** `ChatController::chat_api`
- **Payload:**
  - `to_user`, `message`.
  - `type`: 'text', 'image', 'video', 'post', 'story'.
  - Adjuntos: `url` (file), `video_thumbnail`.
  - IDs de referencia: `post_id`, `reel_id`, `story_id` (para compartir contenido).

## Comportamiento Esperado (Mavoo Flutter)

1.  **Sockets:** Aunque el código analizado usa polling (API HTTP), se recomienda encarecidamente usar WebSockets para chat en tiempo real si el backend lo soporta (referencias a `SocketController` vistas anteriormente).
2.  **Estado de Lectura:** Actualizar visualmente cuando el otro usuario lee el mensaje.
3.  **Multimedia:** Previsualización de imágenes y reproducción de videos dento del chat.
