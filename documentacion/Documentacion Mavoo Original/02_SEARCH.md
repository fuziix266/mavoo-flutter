# Análisis Sección Search (Original)

## Descripción General

La sección de búsqueda permite a los usuarios encontrar otros usuarios y hashtags dentro de la plataforma. Ofrece resultados filtrados y mantiene un historial de "Búsquedas Recientes" almacenado localmente.

**Ubicación Frontend:** `documentacion/front_original/src/app/Search/Search.tsx`
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/UserController.php` (lógica probable).

## Estructura Visual (Frontend)

El componente `Search` (`src/app/Search/Search.tsx`) incluye:

1.  **Barra de Búsqueda:** Input de texto con debounce (500ms).
2.  **Lista de Resultados:** Muestra coincidencias divididas en:
    - **Usuarios:** Foto de perfil, nombre y nombre de usuario.
    - **Hashtags:** Icono #, texto del tag y contador de publicaciones.
3.  **Búsquedas Recientes:** Historial persistente en `localStorage`. Permite eliminar items individuales o limpiar todo.

### Componentes Relacionados

- `ExploreSearch.tsx`: Variante del buscador utilizada probablemente en la sección Explorar.
- `SearchResponse` (Interface): Define la estructura de respuesta esperada: `{ users: User[], hashtags: Hashtag[], ... }`.

## Lógica del Backend (API)

### Búsqueda Mixta (Usuarios y Hashtags)

- **Endpoint en Frontend:** `POST /api/search_users_hashtags`
  - _Nota:_ Este endpoint específico no se encontró explícitamente en `routes/api.php` durante el análisis preliminar del backend. Es posible que sea una ruta renombrada o manejada dinámicamente.
- **Endpoints Relacionados encontrados en API:**
  - `POST /api/search_username` (`UserController::search_username`): Busca usuarios por texto, excluyendo bloqueados.
  - `POST /api/get_hashtags_list`: Posible endpoint para hashtags.

### Funcionalidad Esperada

1.  **Entrada:** Texto de búsqueda (`text`).
2.  **Procesamiento:**
    - Buscar usuarios que coincidan con `username` o `name`.
    - Buscar hashtags que coincidan con el texto.
    - Excluir usuarios bloqueados.
3.  **Salida:** JSON con arrays combinados o separados de `users` y `hashtags`.

## Comportamiento Esperado de Componentes Nuevos

Para `mavoo_flutter`:

1.  **Buscador Unificado:** Un solo input que devuelva tanto personas como temas (hashtags).
2.  **Historial Local:** Implementar persistencia local (SharedPreferences/Hive) para "Búsquedas Recientes".
3.  **Navegación:** Al hacer clic, navegar al Perfil del usuario o a la vista de Feed del Hashtag.
