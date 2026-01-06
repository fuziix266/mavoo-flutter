# Análisis Sección Authentication (Original)

## Descripción General

El sistema de autenticación se basa en **OTP móvil** (One-Time Password) en lugar de contraseñas estáticas, proporcionando una experiencia "passwordless" moderna y segura.

**Ubicación Frontend:** `documentacion/front_original/src/app/(Auth)/` (Carpetas `SignIn`, `Signup`, etc.)
**Ubicación Backend:** `documentacion/back_original/app/Http/Controllers/Api/AuthController.php`

## Flujo de Autenticación

1.  **Ingreso de Móvil:**
    - Usuario ingresa número y código de país.
    - Frontend llama a `POST /api/send_otp`.
2.  **Envío de OTP (Backend):**
    - Valida inputs.
    - Genera OTP aleatorio (o `1234` para números de prueba específicos).
    - Envía SMS usando **Twilio** (internacional) o **MSG91** (India/+91).
    - Crea o actualiza el registro del usuario en DB con el nuevo OTP.
3.  **Verificación:**
    - Usuario ingresa el código recibido.
    - Frontend llama a `POST /api/check_otp` (o `check_otp_new`).
4.  **Login Exitoso:**
    - Backend verifica coincidencia de OTP.
    - Genera y retorna **JWT Access Token** (Laravel Passport/Sanctum).
    - Retorna datos del usuario (Perfil, ID).

## Lógica del Backend (API)

### Endpoints Clave

- `POST /api/send_otp`: Inicia el login/registro. Maneja la creación de usuario si no existe (`User::updateOrCreate`).
- `POST /api/check_otp`: Valida credenciales.
- `POST /api/username_check`: Valida unicidad de nombre de usuario durante el registro/edición.

## Comportamiento Esperado (Mavoo Flutter)

1.  **Input Mask:** Formateo automático del número telefónico.
2.  **Auto-lectura:** En Android, intentar leer el SMS de OTP automáticamente.
3.  **Manejo de Errores:** Mostrar mensajes claros si falla el envío de SMS (ej. cuota excedida, número inválido).
4.  **Persistencia:** Guardar el Token de sesión de forma segura (SecureStorage) para mantener la sesión activa.
