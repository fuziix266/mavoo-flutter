# Análisis Sección Profile (Original)

## Descripción General

El perfil de usuario es el centro de identidad en Mavoo. Muestra información personal, estadísticas (seguidores/seguidos), y el contenido creado por el usuario (Posts, Reels, Etiquetas). Maneja dos estados: "Mi Perfil" (editable) y "Perfil Público" (solo lectura/interacción).

**Ubicación Frontend:** `documentacion/front_original/src/app/Profile/profile.tsx`
**Ubicación Backend:**

- `NuevoProfileController.php` (Perfil Público).
- `AuthController.php` (Edición de Perfil `user_profile2`).
- `FollowController.php` (Listas de seguidores/seguidos).

## Estructura Visual (Frontend)

El componente `Profile.tsx` (y su wrapper `page.tsx`) gestiona:

1.  **Header:** Imagen de portada y foto de perfil.
2.  **Estadísticas:** Contadores de Followers y Following (clickeables para ver listas).
3.  **Acciones:**
    - _Propio:_ "Edit Profile" (abre `Edit_Profile.tsx`).
    - _Otro:_ "Follow/Unfollow", "Message", "Report" (menú de 3 puntos).
4.  **Pestañas de Contenido:**
    - **Posts:** Grid de imágenes.
    - **Reels:** Grid de videos verticales.
    - **Tags:** Posts donde el usuario ha sido etiquetado.
5.  **Eventos:** Muestra sección "Trends" (Eventos) personalizada.

## Lógica del Backend (API)

### Perfil Público

- **Endpoint:** `POST /api/get-public-profile`
- **Controlador:** `NuevoProfileController::getPublicProfile`
- **Datos:**
  - Info básica (`UserResource`).
  - Lists de `posts`, `reels`, `tagged` (paginados, limit 12).
  - Flags de relación: `is_following`, `is_blocked`.

### Mi Perfil (Editar)

- **Endpoint:** `POST /api/user_profile` (Fetch) y `user_profile_edit` (Update, verificar nombre exacto, en `AuthController` vimos `user_profile2`).
- **Lógica:** Permite actualizar bio, imagen, nombre, etc.

### Relaciones

- **Listas:** `POST /api/get_followers_list` / `get_following_list`.
- **Acción:** `POST /api/follow` (Toggle follow/unfollow).

## Comportamiento Esperado (Mavoo Flutter)

1.  **Carga Diferida:** Cargar info básica primero, luego las grids de contenido.
2.  **Optimización de Imágenes:** Usar versiones cacheadas/optimizadas de avatares y portadas.
3.  **Navegación Fluida:** Transición suave entre perfil propio y de otros.
4.  **Estado Global:** Actualizar contadores si se sigue/deja de seguir desde otras vistas.
