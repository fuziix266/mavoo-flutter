# Análisis Sección Home (Original)

## Descripción General

La sección Home es la pantalla principal de la aplicación, donde los usuarios interactúan con el contenido principal: Historias, Publicaciones (Feed), Tendencias y Descubrimiento de nuevos usuarios.

**Ubicación Frontend:** `documentacion/front_original/src/app/Home/page.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/PostController.php`, `StoryController.php`

## Estructura Visual (Frontend)

El layout principal (`Home/page.tsx`) divide la pantalla en:

1.  **Sidebar:** Navegación lateral fija.
2.  **Contenido Principal (Centro):**
    - **Historias (Stories):** Componente `Stories` (`src/app/Home/Story/Slider`). Carrusel de historias de usuarios seguidos.
    - **Buscador/Filtro:** Componente `Search` (`src/app/Home/AddReelPost/Search`).
    - **Tendencias (Trends):** Componente `Trends` (`src/app/Home/Trends/Trends`). Posiblemente "Próximos Eventos" o hashtags populares.
    - **Feed de Publicaciones:** Componente `PostNew` (`src/app/Home/Post/PostNew`). Lista de publicaciones recientes.
3.  **Barra Lateral Derecha (Desktop):**
    - **Descubrir (Discover):** Componente `Discover` (`src/app/Home/Discover/Discover`). Sugerencias de usuarios ("New Partners").

### Modales

La página gestiona varios modales mediante Redux (`useAppSelector`):

- `ShareStory`: Compartir historia.
- `ViewStory`: Ver historia propia.
- `AddStory`: Agregar nueva historia.
- `DeleteMyStory`: Eliminar historia propia.
- `AddPost`: Crear nueva publicación.
- `PostTagPeople`: Etiquetar personas en publicaciones.

## Lógica del Backend (API)

### 1. Feed de Publicaciones

- **Endpoint:** `POST /api/get_all_latest_post` (o `get_all_latest_post_pagination`)
- **Controlador:** `PostController::get_all_latest_post`
- **Funcionalidad:**
  - Obtiene las últimas 20 publicaciones de tipo 'image' (o mezcla con reels si usa `get_all_latest_reel_and_post`).
  - Incluye detalles del usuario (foto, nombre).
  - Incluye imágenes (`PostImages`) y videos (`PostVideos`) asociados.
  - Calcula contadores: Likes (`PostLike`), Comentarios (`PostComment`).
  - Verifica si el usuario actual dio like (`is_likes`).
  - Retorna respuesta JSON con `response_code: 1` si hay éxito.

### 2. Historias (Stories)

- **Endpoint:** `POST /api/get_story_by_user`
- **Controlador:** `StoryController::get_story_by_user`
- **Funcionalidad:**
  - Obtiene historias de usuarios seguidos (`follow` table).
  - Si no sigue a nadie, muestra historias globales o sugeridas.
  - Agrupa historias por usuario.
  - Endpoint para crear historia: `POST /api/add_story`. Soporta imágenes y videos (S3 o local).
  - Elimina historias antiguas automáticamente (logic in controller check 24h).

### 3. Sugerencias (Discover/New Partners)

- **Endpoint probable:** `POST /api/all_userlist` o `POST /api/search_userlist`
- **Controlador:** `UserController`
- **Funcionalidad:** Lista usuarios recomendados o nuevos para seguir.

### 4. Creación de Contenido

- **Crear Post:** `POST /api/add_post` (`PostController::add_post`)
  - Recibe texto, ubicación, imágenes/videos.
  - Procesa hashtags (`#`) y menciones (`@`/tag_users).
  - Envía notificaciones push a usuarios etiquetados.
- **Crear Reel:** `POST /api/add_reel` (`PostController::add_reel`)

## Comportamiento Esperado de Componentes Nuevos

Para `mavoo_flutter` y el nuevo backend `mavoo_laminas`, se debe replicar:

1.  **Feed Infinito:** Carga paginada de posts.
2.  **Stories:** Carrusel superior con lógica de expiración 24h visual.
3.  **Interacciones:** Like animado, comentarios en tiempo real (o visualización instantánea).
4.  **Carga Multimedia:** Soporte robusto para imágenes y videos (optimizar carga).
