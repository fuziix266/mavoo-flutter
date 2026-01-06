# API Endpoints - Sistema de Eventos

## Base URL

`/content/event`

## Endpoints Disponibles

### 1. Listar Eventos Próximos

**GET** `/content/event/upcoming`

**Query Parameters**:

- `limit` (opcional): Número máximo de eventos a retornar (default: 10)

**Response**:

```json
{
  "success": true,
  "events": [
    {
      "id": 1,
      "name": "Torneo de Fútbol 7",
      "description": "Torneo amistoso...",
      "sport": "Fútbol 7",
      "date": "2025-01-15 18:00:00",
      "location": "Cancha Municipal de Arica",
      "max_participants": 56,
      "current_participants": 12,
      "organizer_id": 1,
      "image_url": null,
      "status": "upcoming",
      "is_full": false
    }
  ],
  "count": 5
}
```

### 2. Crear Evento

**POST** `/content/event/create`

**Body**:

```json
{
  "name": "Torneo de Pádel",
  "description": "Campeonato de pádel...",
  "sport": "Pádel",
  "event_date": "2025-02-01 09:00:00",
  "location": "Club Deportivo",
  "max_participants": 32,
  "image_url": "https://...",
  "organizer_id": 1
}
```

**Response**:

```json
{
  "success": true,
  "message": "Evento creado exitosamente",
  "event_id": 6
}
```

### 3. Detalles de Evento

**GET** `/content/event/details/:id`

**Response**:

```json
{
  "success": true,
  "event": {
    "id": 1,
    "name": "Torneo de Fútbol 7",
    "description": "...",
    "sport": "Fútbol 7",
    "date": "2025-01-15 18:00:00",
    "location": "Cancha Municipal",
    "max_participants": 56,
    "current_participants": 12,
    "organizer_id": 1,
    "image_url": null,
    "status": "upcoming",
    "is_full": false
  }
}
```

### 4. Eliminar Evento

**DELETE** `/content/event/delete/:id`

**Response**:

```json
{
  "success": true,
  "message": "Evento eliminado exitosamente"
}
```

---

## Endpoints de Inscripciones

### 5. Inscribirse a Evento

**POST** `/content/event/:id/register`

**Body**:

```json
{
  "user_id": 5
}
```

**Response**:

```json
{
  "success": true,
  "message": "Inscripción exitosa",
  "registration_id": 15
}
```

**Errores posibles**:

- Evento lleno
- Ya inscrito
- Evento no disponible

### 6. Cancelar Inscripción

**POST/DELETE** `/content/event/:id/unregister`

**Body**:

```json
{
  "user_id": 5
}
```

**Response**:

```json
{
  "success": true,
  "message": "Inscripción cancelada"
}
```

### 7. Ver Participantes

**GET** `/content/event/:id/participants`

**Response**:

```json
{
  "success": true,
  "participants": [
    {
      "user_id": 5,
      "registered_at": "2025-01-10 14:30:00",
      "status": "registered"
    }
  ],
  "count": 12
}
```

### 8. Eventos del Usuario

**GET** `/content/event/user-events/:userId`

**Response**:

```json
{
  "success": true,
  "registrations": [
    {
      "event_id": 1,
      "registered_at": "2025-01-10 14:30:00",
      "status": "registered"
    }
  ],
  "count": 3
}
```

---

## Códigos de Estado

- `200 OK`: Operación exitosa
- `400 Bad Request`: Parámetros inválidos
- `404 Not Found`: Recurso no encontrado
- `500 Internal Server Error`: Error del servidor

## Notas

- Todos los endpoints retornan JSON
- Las fechas están en formato `YYYY-MM-DD HH:MM:SS`
- Los IDs son enteros positivos
- El `user_id` actualmente se envía en el body, pero debería obtenerse del token JWT en producción
