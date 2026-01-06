# Análisis Sección Add Post (Original)

## Descripción General

La funcionalidad "Add Post" permite a los usuarios crear nuevas publicaciones, ya sean imágenes (Post) o videos cortos (Reels). Incluye capacidades avanzadas como geolocalización, etiquetado de usuarios y uso de hashtags.

**Ubicación Frontend:** `documentacion/front_original/src/app/components/AddPost.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/PostController.php` (función `add_post`).

## Estructura Visual y Lógica (Frontend)

El componente `AddPost.tsx` funciona como un Modal:

1.  **Selección de Multimedia:**
    - Soporta selección múltiple de imágenes y videos.
    - Genera automáticamente miniaturas (thumbnails) para videos usando Canvas y un elemento `<video>` oculto.
    - Determina el `post_type` ('reel' si hay video, 'image' si solo fotos).
2.  **Edición de Texto:**
    - Input para descripción (caption).
    - **Autocompletado de Hashtags:** Detecta el carácter `#` y muestra una lista filtrada obtenida de `useGetHashtagListQuery`.
3.  **Localización:**
    - Integra **Google Places Autocomplete** para buscar y seleccionar ubicaciones (`lat`, `lng`, nombre).
4.  **Etiquetado (Tag People):**
    - Abre el sub-componente `TagPeople` para seleccionar usuarios seguidos.
    - Almacena los IDs seleccionados en `tag_users`.

## Lógica del Backend (API)

### Crear Publicación

- **Endpoint:** `POST /api/add_post`
- **Controlador:** `PostController::add_post`
- **Parámetros:**
  - `text`, `location`, `post_type`, `tag_users` (CSV strings).
  - Archivos: `post_image[]`, `post_video[]`, `post_video_thumbnail[]`.
- **Procesamiento:**
  1.  Crea registro en tabla `posts`.
  2.  **Manejo de Archivos:**
      - Sube archivos a **AWS S3** si las credenciales existen en config.
      - Fallback a almacenamiento local (`public/assets/images/...`) si S3 falla o no está configurado.
      - Guarda referencias en tablas `post_images` o `post_videos`.
  3.  **Hashtags:**
      - Extrae hashtags del texto usando Regex.
      - Guarda en tabla `hash_tags`.
  4.  **Etiquetas y Notificaciones:**
      - Procesa `tag_users`.
      - Crea registros en `post_user_tags`.
      - Envía **Notificaciones Push** (Firebase) y notificaciones in-app (`user_notification`) a los usuarios etiquetados.

## Comportamiento Esperado (Mavoo Flutter)

1.  **Gestión de Permisos:** Solicitar acceso a galería/cámara y ubicación.
2.  **Compresión:** Optimizar imágenes/videos antes de subir para reducir consumo de datos.
3.  **Feedback Visual:** Mostrar progreso de subida (loading spinner o barra de progreso).
4.  **Google Maps:** Configurar correctamente la API Key de Google Maps en el proyecto Flutter.
