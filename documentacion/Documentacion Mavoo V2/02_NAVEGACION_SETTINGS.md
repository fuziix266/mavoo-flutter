# Documentación Técnica: Navegación, Settings y Logout

## Resumen

Este documento describe la arquitectura de navegación persistente utilizando `ShellRoute`, la implementación de alta fidelidad de la página de Configuración (Settings) y el flujo completo de cierre de sesión (Logout).

---

## 1. NAVEGACIÓN Y LAYOUT (Flutter)

### 1.1 Configuración de Rutas: ShellRoute

**Archivo:** `mavoo_flutter/lib/main.dart`

**Implementación:**
Se utiliza `ShellRoute` de `go_router` para mantener una estructura de UI persistente (`MainLayout`) que envuelve a las páginas hijas. Esto permite que la barra lateral (`AppSidebar`) permanezca visible y conserve su estado mientras se navega entre `Home`, `Search`, `Settings`, etc.

```dart
ShellRoute(
  builder: (context, state, child) {
    return MainLayout(
      currentLocation: state.uri.toString(),
      child: child,
    );
  },
  routes: [
    GoRoute(path: '/home', ...),
    GoRoute(path: '/settings', ...),
    // ... otras rutas
  ],
)
```

### 1.2 Layout Principal: MainLayout

**Archivo:** `mavoo_flutter/lib/core/widgets/main_layout.dart`

**Función:**
Actúa como el "scaffold" principal para usuarios autenticados.

- **Responsividad:** Detecta el ancho de pantalla (`MediaQuery`).
- **Sidebar:** Renderiza `AppSidebar` a la izquierda en pantallas grandes (`> 900px`).
- **Contenido Dinámico:** Renderiza el `child` (página actual) en el área principal.
- **Escucha de Auth:** Implementa `BlocListener` para redirigir al login si el estado cambia a `AuthUnauthenticated`.

---

## 2. UI: SETTINGS PAGE & SIDEBAR

### 2.1 AppSidebar

**Archivo:** `mavoo_flutter/lib/core/widgets/app_sidebar.dart`

**Características:**

- Navegación lateral persistente.
- Botón de perfil interactivo que redirige a `/profile`.
- Diseño responsivo adaptado del proyecto original en Next.js.

### 2.2 SettingsPage (Alta Fidelidad)

**Archivo:** `mavoo_flutter/lib/features/settings/presentation/pages/settings_page.dart`

**Diseño:**
Replica exactamente el diseño de `Settings.tsx` del proyecto Next.js:

- **Header:** Fondo con gradiente y superposición de imágenes, foto de perfil centrada con sombra, indicador de estado "Online".
- **Opciones:** "Saved Bookmark", "Block Contacts", "Terms & Conditions", etc., con iconografía y tipografía (`Gilroy`) fiel al original.
- **Logout:** Opción destacada en rojo que invoca un diálogo de confirmación.
- **Delete Account:** Botón con gradiente personalizado al final de la lista.

---

## 3. FLUJO DE LOGOUT

### 3.1 UI: Diálogo de Confirmación

**Archivo:** `mavoo_flutter/lib/features/settings/presentation/pages/settings_page.dart`

**Función:** `_showLogoutDialog()`
Muestra alerta. Si el usuario confirma, dispara el evento `AuthLogoutRequested`.

```dart
context.read<AuthBloc>().add(AuthLogoutRequested());
```

### 3.2 BLoC: AuthBloc

**Archivo:** `mavoo_flutter/lib/features/auth/presentation/bloc/auth_bloc.dart`

**Función:** `_onLogoutRequested()`

- Invoca `LogoutUseCase`.
- Emite estado `AuthUnauthenticated`.

```dart
Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
  await logoutUseCase();
  emit(AuthUnauthenticated());
}
```

### 3.3 Data Layer: AuthRepository & LocalDataSource

**Archivos:**

- `mavoo_flutter/lib/features/auth/data/repositories/auth_repository_impl.dart`
- `mavoo_flutter/lib/features/auth/data/datasources/auth_local_data_source.dart`

**Acción:**
Elimina el token JWT y los datos del usuario de `SharedPreferences`.

```dart
// AuthLocalDataSourceImpl
Future<void> clearCache() async {
  await sharedPreferences.remove(CACHED_TOKEN);
  await sharedPreferences.remove(CACHED_USER);
}
```

### 3.4 Redirección

**Archivo:** `mavoo_flutter/lib/core/widgets/main_layout.dart`

El `BlocListener` detecta `AuthUnauthenticated` y redirige a la ruta raíz `/`.

```dart
if (state is AuthUnauthenticated) {
  context.go('/');
}
```

---

## 4. ARCHIVOS CREADOS/MODIFICADOS

### Core & Utils

1. `lib/core/widgets/main_layout.dart` (Nuevo: Estructura persistente)
2. `lib/core/widgets/app_sidebar.dart` (Modificado: Navegación perfil)
3. `lib/core/widgets/placeholder_page.dart` (Nuevo: Páginas en construcción)

### Settings Feature

4. `lib/features/settings/presentation/pages/settings_page.dart` (Nuevo: UI completa)

### Auth Feature (Actualizaciones)

5. `lib/features/auth/domain/usecases/logout_usecase.dart` (Nuevo)
6. `lib/features/auth/data/datasources/auth_local_data_source.dart` (Modificado: clearCaché)

---

**Fecha de documentación:** 2025-12-18
**Versión:** 1.0
**Estado:** ✅ Implementado y Verificado
