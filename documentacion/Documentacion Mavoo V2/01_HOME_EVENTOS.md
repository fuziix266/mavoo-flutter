# Implementación HOME - Sistema de Eventos

## Fecha: 2025-12-23

## Descripción

Implementación del sistema de eventos para la sección HOME, replicando la funcionalidad original de "Próximos Eventos" del código Next.js.

## Cambios en Base de Datos

### Nuevas Tablas

#### `events`

Almacena información de eventos deportivos organizados por usuarios.

**Campos principales**:

- `name`: Nombre del evento
- `sport`: Tipo de deporte (Fútbol 7, Pádel, Tenis, etc.)
- `event_date`: Fecha y hora del evento
- `location`: Ubicación
- `max_participants`: Capacidad máxima
- `current_participants`: Participantes actuales
- `organizer_id`: Usuario organizador (FK a `users`)
- `status`: Estado (upcoming, ongoing, completed, cancelled)

#### `event_registrations`

Registra las inscripciones de usuarios a eventos.

**Campos principales**:

- `event_id`: FK a `events`
- `user_id`: FK a `users`
- `status`: Estado de inscripción (registered, confirmed, cancelled)

**Archivo SQL**: `documentacion/base de datos/001_create_events_tables.sql`

## Backend (Laminas)

### Nuevos Archivos

#### 1. `Content\Model\Event.php`

Modelo de datos para eventos.

#### 2. `Content\Model\EventTable.php`

Gateway para operaciones de BD en tabla `events`.

**Métodos principales**:

- `getUpcomingEvents($limit)`: Obtiene eventos próximos
- `saveEvent(Event $event)`: Crea/actualiza evento
- `incrementParticipants($eventId)`: Incrementa contador de participantes
- `decrementParticipants($eventId)`: Decrementa contador

#### 3. `Content\Controller\EventController.php` (próximo)

Controlador REST para endpoints de eventos.

**Endpoints planificados**:

- `GET /api/events/upcoming`: Lista eventos próximos
- `POST /api/events/create`: Crear nuevo evento
- `POST /api/events/{id}/register`: Inscribirse a evento
- `DELETE /api/events/{id}/unregister`: Cancelar inscripción
- `GET /api/events/{id}/participants`: Ver participantes

## Frontend (Flutter)

### Estructura Planificada

```
lib/features/events/
├── data/
│   ├── models/
│   │   ├── event_model.dart
│   │   └── event_registration_model.dart
│   ├── repositories/
│   │   └── event_repository.dart
│   └── datasources/
│       └── event_remote_datasource.dart
├── domain/
│   ├── entities/
│   │   └── event.dart
│   └── usecases/
│       ├── get_upcoming_events.dart
│       └── register_to_event.dart
└── presentation/
    └── widgets/
        └── events_section.dart
```

### Componente Principal

**`events_section.dart`**

- Réplica del diseño original `Trends.tsx`
- Gradiente azul característico de Mavoo
- Tarjetas de eventos con información
- Botón "Inscribirme"
- Skeleton loading

## Diseño Visual

Basado en el componente original:

- **Header**: "Próximos Eventos" con icono de calendario
- **Fondo**: Gradiente blanco/azul con blur
- **Tarjetas**: Fondo blanco semi-transparente
- **Badge**: Deporte en badge azul
- **Botón**: Gradiente azul (#0046fc → #00b2f6)

## Próximos Pasos

1. ✅ Crear tablas de BD
2. ✅ Crear modelos Event y EventTable
3. ⏳ Crear EventController con endpoints
4. ⏳ Crear EventRegistrationTable
5. ⏳ Configurar rutas en module.config.php
6. ⏳ Implementar modelos Flutter
7. ⏳ Implementar UI de EventsSection
8. ⏳ Integrar en HomePage

## Notas Técnicas

- Los eventos usan zona horaria del servidor
- Las inscripciones tienen constraint UNIQUE para evitar duplicados
- El contador de participantes se actualiza automáticamente
- Los eventos pasados no se muestran en el feed
