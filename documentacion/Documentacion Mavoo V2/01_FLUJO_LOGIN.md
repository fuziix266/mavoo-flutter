# Documentación Técnica: Flujo de Autenticación (Login)

## Resumen

Este documento describe el flujo completo de autenticación desde que el usuario presiona "Login" en Flutter hasta que recibe la respuesta del backend Laminas.

---

## 1. FRONTEND (Flutter) - Inicio del Flujo

### 1.1 UI: LoginPage

**Archivo:** `mavoo_flutter/lib/features/auth/presentation/pages/login_page.dart`

**Función:** `_handleLogin()` (línea 311)

- **Qué hace:** Captura email y password de los controladores de texto
- **Parámetros de entrada:**
  - `_emailController.text` (String)
  - `_passwordController.text` (String)
- **Llamada siguiente:** Dispara evento `AuthLoginRequested` al `AuthBloc`

```dart
void _handleLogin() {
  context.read<AuthBloc>().add(
    AuthLoginRequested(
      email: _emailController.text,
      password: _passwordController.text,
    ),
  );
}
```

---

### 1.2 BLoC: AuthBloc

**Archivo:** `mavoo_flutter/lib/features/auth/presentation/bloc/auth_bloc.dart`

**Función:** `_onLoginRequested()` (línea 22)

- **Qué hace:** Maneja el evento de login, emite estados (Loading, Authenticated, Error)
- **Parámetros de entrada:**
  - `event.email` (String)
  - `event.password` (String)
- **Llamada siguiente:** Invoca `LoginUseCase`
- **Estados emitidos:**
  - `AuthLoading()` - Antes de la petición
  - `AuthAuthenticated(user)` - Si login exitoso
  - `AuthError(message)` - Si falla

```dart
Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  final result = await loginUseCase(event.email, event.password);
  result.fold(
    (failure) => emit(AuthError(failure.message)),
    (user) => emit(AuthAuthenticated(user)),
  );
}
```

---

### 1.3 Use Case: LoginUseCase

**Archivo:** `mavoo_flutter/lib/features/auth/domain/usecases/login_usecase.dart`

**Función:** `call()` (línea 8)

- **Qué hace:** Encapsula la lógica de negocio del login
- **Parámetros de entrada:**
  - `email` (String)
  - `password` (String)
- **Llamada siguiente:** Invoca `repository.login()`
- **Retorno:** `Either<Failure, User>` (éxito o error)

```dart
Future<Either<Failure, User>> call(String email, String password) {
  return repository.login(email, password);
}
```

---

### 1.4 Repository: AuthRepositoryImpl

**Archivo:** `mavoo_flutter/lib/features/auth/data/repositories/auth_repository_impl.dart`

**Función:** `login()` (línea 13)

- **Qué hace:** Coordina entre la capa de dominio y la capa de datos
- **Parámetros de entrada:**
  - `email` (String)
  - `password` (String)
- **Llamada siguiente:** Invoca `remoteDataSource.login()`
- **Manejo de errores:** Captura `ServerFailure` y otras excepciones
- **Retorno:** `Either<Failure, User>`

```dart
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final user = await remoteDataSource.login(email, password);
    return Right(user);
  } on ServerFailure catch (e) {
    return Left(e);
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

---

### 1.5 Data Source: AuthRemoteDataSourceImpl

**Archivo:** `mavoo_flutter/lib/features/auth/data/datasources/auth_remote_data_source.dart`

**Función:** `login()` (línea 18)

- **Qué hace:** Realiza la petición HTTP al backend
- **Parámetros de entrada:**
  - `email` (String)
  - `password` (String)
- **Endpoint llamado:** `POST http://localhost:8080/auth/login`
- **Body enviado:**
  ```json
  {
    "email": "test@mavoo.app",
    "password": "password123"
  }
  ```
- **Respuesta esperada:**
  ```json
  {
    "status": 200,
    "message": "Login successful",
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 2,
      "first_name": "testuser",
      "last_name": null,
      "email": "test@mavoo.app"
    }
  }
  ```
- **Procesamiento:**
  1. Verifica `status == 200`
  2. Combina `data['user']` + `data['token']` en un solo objeto
  3. Convierte a `UserModel` usando `fromJson()`
- **Retorno:** `UserModel`
- **Excepciones:** Lanza `ServerFailure` si hay error

---

## 2. BACKEND (Laminas) - Procesamiento

### 2.1 Routing

**Archivo:** `mavoo_laminas_back/module/Auth/config/module.config.php`

**Ruta:** `/auth/login`

- **Tipo:** Literal
- **Método HTTP:** POST
- **Controlador:** `Auth\Controller\AuthController`
- **Acción:** `loginAction`

```php
'auth-login' => [
    'type' => Literal::class,
    'options' => [
        'route' => '/auth/login',
        'defaults' => [
            'controller' => Controller\AuthController::class,
            'action' => 'login',
        ],
    ],
],
```

---

### 2.2 Controller: AuthController

**Archivo:** `mavoo_laminas_back/module/Auth/src/Controller/AuthController.php`

**Función:** `loginAction()` (línea 19)

- **Qué hace:** Procesa la petición de login
- **Parámetros de entrada:**
  - `$email` (extraído del body JSON)
  - `$password` (extraído del body JSON)
- **Validaciones:**
  1. Verifica que sea petición POST
  2. Verifica que email y password no estén vacíos
- **Llamada siguiente:** `$this->table->getUserByEmail($email)`
- **Procesamiento:**
  1. Obtiene usuario de la BD
  2. Verifica contraseña con `password_verify()`
  3. Genera token JWT con `Firebase\JWT\JWT::encode()`
- **Respuesta:**
  ```php
  return new JsonModel([
      'status' => 200,
      'message' => 'Login successful',
      'token' => $token,
      'user' => [
          'id' => $user->id,
          'first_name' => $user->first_name,
          'last_name' => $user->last_name,
          'email' => $user->email
      ]
  ]);
  ```
- **Errores posibles:**
  - 405: Método no permitido (no POST)
  - 400: Credenciales faltantes
  - 404: Usuario no encontrado
  - 401: Contraseña inválida

---

### 2.3 Model: UserTable

**Archivo:** `mavoo_laminas_back/module/Auth/src/Model/UserTable.php`

**Función:** `getUserByEmail()` (línea ~16)

- **Qué hace:** Busca un usuario en la base de datos por email
- **Parámetros de entrada:**
  - `$email` (String)
- **Query SQL ejecutada:**
  ```sql
  SELECT * FROM users WHERE email = :email LIMIT 1
  ```
- **Base de datos:** `mavoo_db` (tabla `users`)
- **Retorno:** Objeto `User` o `null` si no existe

**Estructura de la tabla `users`:**

```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,  -- Hash bcrypt
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  username VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

## 3. FLUJO DE RETORNO (Backend → Frontend)

### 3.1 Parsing en Flutter

**Archivo:** `mavoo_flutter/lib/features/auth/data/models/user_model.dart`

**Función:** `fromJson()` (línea 18)

- **Qué hace:** Convierte JSON del backend a objeto `UserModel`
- **Mapeo de campos:**
  - `id` → `user.id`
  - `first_name` + `last_name` → `user.fullName`
  - `email` → `user.email`
  - `token` → `user.token`
- **Procesamiento especial:**
  - Combina `first_name` y `last_name` en un solo campo `fullName`
  - Maneja valores `null` con operador `??`

```dart
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id']?.toString() ?? '0',
    email: json['email'] ?? '',
    username: json['username'] ?? json['email']?.split('@').first ?? '',
    fullName: '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
    profileImage: json['profile_image'],
    token: json['token'],
  );
}
```

---

### 3.2 Navegación Post-Login

**Archivo:** `mavoo_flutter/lib/features/auth/presentation/pages/login_page.dart`

**Widget:** `BlocListener<AuthBloc, AuthState>` (línea 182)

- **Qué hace:** Escucha cambios de estado del `AuthBloc`
- **Condición:** Si `state is AuthAuthenticated`
- **Acción:** Navega a `/home` usando `context.go('/home')`

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      context.go('/home');
    }
  },
  child: BlocBuilder<AuthBloc, AuthState>(...),
)
```

---

## 4. DIAGRAMA DE FLUJO COMPLETO

```
[Usuario presiona "Login"]
         ↓
[LoginPage._handleLogin()]
         ↓
[AuthBloc.add(AuthLoginRequested)]
         ↓
[AuthBloc._onLoginRequested()] → emit(AuthLoading)
         ↓
[LoginUseCase.call(email, password)]
         ↓
[AuthRepositoryImpl.login(email, password)]
         ↓
[AuthRemoteDataSourceImpl.login(email, password)]
         ↓
[HTTP POST → http://localhost:8080/auth/login]
         ↓
═══════════════════════════════════════════════════
         ↓ BACKEND
[Laminas Router] → /auth/login
         ↓
[AuthController.loginAction()]
         ↓
[UserTable.getUserByEmail(email)]
         ↓
[SQL Query: SELECT * FROM users WHERE email = ?]
         ↓
[password_verify($password, $user->password)]
         ↓
[JWT::encode($payload, $key, 'HS256')]
         ↓
[JsonModel response con token + user]
         ↓
═══════════════════════════════════════════════════
         ↓ FRONTEND
[AuthRemoteDataSourceImpl recibe respuesta]
         ↓
[UserModel.fromJson(response.data)]
         ↓
[AuthRepositoryImpl retorna Right(user)]
         ↓
[LoginUseCase retorna Either<Failure, User>]
         ↓
[AuthBloc._onLoginRequested()] → emit(AuthAuthenticated(user))
         ↓
[BlocListener detecta AuthAuthenticated]
         ↓
[context.go('/home')]
         ↓
[Usuario ve HomePage]
```

---

## 5. ARCHIVOS INVOLUCRADOS (Resumen)

### Flutter (Frontend)

1. `lib/features/auth/presentation/pages/login_page.dart` - UI
2. `lib/features/auth/presentation/bloc/auth_bloc.dart` - Gestión de estado
3. `lib/features/auth/domain/usecases/login_usecase.dart` - Lógica de negocio
4. `lib/features/auth/domain/repositories/auth_repository.dart` - Interfaz
5. `lib/features/auth/data/repositories/auth_repository_impl.dart` - Implementación
6. `lib/features/auth/data/datasources/auth_remote_data_source.dart` - HTTP Client
7. `lib/features/auth/data/models/user_model.dart` - Modelo de datos
8. `lib/features/auth/domain/entities/user.dart` - Entidad de dominio
9. `lib/core/utils/api_client.dart` - Cliente Dio
10. `lib/core/utils/api_constants.dart` - Constantes de endpoints

### Laminas (Backend)

1. `module/Auth/config/module.config.php` - Configuración de rutas
2. `module/Auth/src/Controller/AuthController.php` - Controlador
3. `module/Auth/src/Model/UserTable.php` - Modelo de tabla
4. `module/Auth/src/Model/User.php` - Entidad de usuario

### Base de Datos

- **Nombre:** `mavoo_db`
- **Tabla:** `users`
- **Campos usados:** `id`, `email`, `password`, `first_name`, `last_name`

---

## 6. NOTAS IMPORTANTES

### Seguridad

- ⚠️ **JWT Secret Key:** Actualmente hardcodeada como `'YOUR_SECRET_KEY_HERE_CHANGE_IN_PRODUCTION'`
- ⚠️ **Debe moverse a:** Variable de entorno o archivo de configuración
- ✅ **Password Hashing:** Usa `password_verify()` con bcrypt

### Pendientes

- [x] Implementar persistencia del token en Flutter (`shared_preferences`)
- [x] Agregar interceptor de Dio para enviar token en peticiones autenticadas
- [x] Implementar auto-login al abrir la app
- [x] Implementar logout (borrar token local)

---

**Fecha de documentación:** 2025-12-18  
**Versión:** 1.0  
**Estado:** ✅ Funcional y verificado
