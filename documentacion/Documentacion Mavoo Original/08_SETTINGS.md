# Análisis Sección Settings (Original)

## Descripción General

El menú de Configuración permite al usuario gestionar aspectos de su cuenta como marcadores guardados, usuarios bloqueados, idioma, y acceder a documentos legales (T&C, Privacidad). También incluye la opción de eliminar cuenta y cerrar sesión.

**Ubicación Frontend:** `documentacion/front_original/src/app/Setting/Settings.tsx`
**Ubicación Backend:**

- `LanguageController.php` (Gestión de idiomas).
- `UserController.php` (Bloqueo, Perfil).
- `PostController.php` (Marcadores).

## Estructura Visual (Frontend)

El componente `Settings.tsx` presenta un sidebar (en escritorio) o lista (en móvil) con las siguientes opciones:

1.  **Perfil Resumido:** Foto, nombre y estado "Online".
2.  **Opciones de Menú:**
    - **Saved Bookmark:** Lista de posts/reels guardados.
    - **Block Contacts:** Lista de usuarios bloqueados.
    - **Terms & Conditions / Privacy Policy:** Vistas de texto informativo.
    - **Language:** Modal para cambiar el idioma de la app.
    - **Logout:** Cerrar sesión.
    - **Delete Account:** Eliminar cuenta permanentemente.

## Lógica del Backend (API)

### Gestión de Idiomas

- **Controlador:** `LanguageController`.
- **Endpoints:**
  - `POST /api/listAllLanguages`: Lista idiomas disponibles.
  - `POST /api/fetchDefaultLanguage`: Obtiene traducciones para el idioma seleccionado.
  - _Nota:_ El backend utiliza un servicio externo (FastAPI en puerto 3692) para traducir keys dinámicamente si es necesario.

### Marcadores (Bookmarks)

- **Endpoint:** `POST /api/get_bookmark_post_list` (Inferido de `BookmarkPostList` query).
- **Lógica:** Retorna posts marcados por el usuario.

### Usuarios Bloqueados

- **Endpoint:** `POST /api/get_blocked_user_list`.
- **Lógica:** Retorna lista de usuarios bloqueados para gestionar desbloqueo.

### Eliminación de Cuenta

- **Endpoint:** `POST /api/delete_account` (Verificar en `UserController`).
- **Acción:** Soft delete o hard delete de los datos del usuario.

## Comportamiento Esperado (Mavoo Flutter)

1.  **Persistencia de Configuración:** Guardar preferencia de idioma localmente.
2.  **Seguridad:** Confirmación explícita para acciones destructivas (Delete Account).
3.  **Legal:** Cargar T&C y Política de Privacidad desde el backend (no hardcoded) para facilitar actualizaciones.
