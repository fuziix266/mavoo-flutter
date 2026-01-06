# Análisis Sección Explore (Original)

## Descripción General

La sección Explore permite a los usuarios descubrir contenido popular (imágenes y videos) que no necesariamente provienen de cuentas que siguen.

**Ubicación Frontend:** `documentacion/front_original/src/app/Explore/page.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/PostController.php` (función `explore`).

## Estructura Visual (Frontend)

El componente principal es `PostReel` (`src/app/Explore/PostReel.tsx`), envuelto en `Explore/page.tsx`.

- **Grid de Contenido:** Muestra una cuadrícula o lista de publicaciones.
- **Interacciones:** Permite ver detalles del post, dar like, comentar, etc.
- **Buscador:** Es probable que integre `ExploreSearch` para permitir búsquedas desde esta pantalla (pendiente de confirmación en `PostReel.tsx`).

## Lógica del Backend (API)

### API de Explorar

- **Endpoint:** `POST /api/explore`
- **Controlador:** `PostController::explore`
- **Lógica de Selección:**
  - Selecciona los posts con mayor cantidad de likes (usados como proxy de "vistas" o popularidad, tabla `post_like`).
  - Ordena descendientemente por este conteo.
  - Retorna lista de posts con imágenes/videos y detalles del usuario.
  - Formateo de URLs de imágenes/videos (S3 o local).

## Comportamiento Esperado (Mavoo Flutter)

1.  **Algoritmo de Popularidad:** Mostrar contenido relevante o trending.
2.  **Grid Multimedia:** Visualización atractiva tipo mosaico (Pinterest/Instagram style) si es posible, o feed vertical.
3.  **Reproducción Automática:** Videos/Reels deberían reproducirse al estar en foco (opcional pero deseable).
