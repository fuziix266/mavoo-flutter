# Análisis Sección Reels (Original)

## Descripción General

La sección Reels ofrece una experiencia inmersiva de videos cortos en formato vertical, similar a TikTok o Instagram Reels. Permite deslizar (scroll) infinito, dar likes, comentar y compartir.

**Ubicación Frontend:** `documentacion/front_original/src/app/Reels/Reels.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/PostController.php`

## Estructura Visual (Frontend)

El componente `Reels.tsx` maneja:

1.  **Feed Vertical:** Lista de videos que ocupan toda la pantalla.
2.  **Reproducción:**
    - Autoplay del video visible.
    - Mute/Unmute.
    - Detección de visibilidad para pausar/reproducir.
3.  **Interacciones:**
    - Botones superpuestos a la derecha: Like, Comment (abre modal), Share, More Options.
    - Info inferior: Usuario, descripción (text), música.
4.  **Componentes Auxiliares:**
    - `ReelLike.tsx`: Animación/lógica de like.
    - `ReportReel.tsx`: Modal para reportar contenido inapropiado.
    - `ShareReel.tsx`: Botón/modal para compartir.

## Lógica del Backend (API)

### Obtener Reels

- **Endpoint:** `POST /api/get_all_reels` (o `get_all_latest_post` filtrado por type='reel' si no hay específico, verificar endpoint exacto en `Reels.tsx`).
  - _Nota:_ En `Explore` se usaba `get_all_reels_datainshow`. Es probable que aquí se use uno similar o el mismo.
- **Controlador:** `PostController`.
- **Datos:**
  - Video URL (S3/local).
  - Thumbnail.
  - Counts: Likes, Comments.
  - User Info.

### Interacciones

- **Like:** `POST /api/post_like` (El mismo endpoint para posts y reels, o específico `reel_like`).
- **Comment:** `POST /api/post_comment` (o `reel_comment`).

## Comportamiento Esperado (Mavoo Flutter)

1.  **Performance:** Carga rápida de videos (caching/prefetching).
2.  **Gestos:** Swipe up/down fluido.
3.  **Sonido:** Manejo inteligente del audio (si el usuario lo activa, mantener activo para siguientes videos).
4.  **Pantalla Completa:** Ocultar barras de navegación si es necesario para inmersión total.
