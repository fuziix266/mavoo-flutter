# API Endpoints - Sistema de Stories

## Base URL

`/content/story`

## Endpoints Disponibles

### 1. Feed de Stories

**GET** `/content/story/feed`

**Query Parameters**:

- `user_id` (requerido): ID del usuario actual

**Response**:

```json
{
  "success": true,
  "users": [
    {
      "user_id": 5,
      "stories": [
        {
          "story_id": 1,
          "url": "https://...",
          "video_thumbnail": null,
          "location": "",
          "text": "",
          "type": "image",
          "created_at": "2025-12-23 10:00:00",
          "has_viewed": false
        }
      ],
      "has_unviewed": true
    }
  ],
  "count": 3
}
```

### 2. Crear Story

**POST** `/content/story/create`

**Body**:

```json
{
  "user_id": 1,
  "url": "https://...",
  "type": "image",
  "video_thumbnail": "https://...",
  "location": "Arica, Chile",
  "text": "Mi historia"
}
```

**Response**:

```json
{
  "success": true,
  "message": "Historia creada exitosamente",
  "story_id": 15
}
```

### 3. Marcar Story como Vista

**POST** `/content/story/:id/view`

**Body**:

```json
{
  "user_id": 1
}
```

**Response**:

```json
{
  "success": true,
  "message": "Historia marcada como vista"
}
```

### 4. Eliminar Story Propia

**DELETE/POST** `/content/story/delete/:id`

**Body**:

```json
{
  "user_id": 1
}
```

**Response**:

```json
{
  "success": true,
  "message": "Historia eliminada exitosamente"
}
```

### 5. Mis Stories

**GET** `/content/story/my-stories`

**Query Parameters**:

- `user_id` (requerido): ID del usuario

**Response**:

```json
{
  "success": true,
  "stories": [
    {
      "story_id": 1,
      "url": "https://...",
      "video_thumbnail": null,
      "location": "",
      "text": "",
      "type": "image",
      "created_at": "2025-12-23 10:00:00",
      "view_count": 15
    }
  ],
  "count": 2
}
```

### 6. Ver Visualizaciones de Story

**GET** `/content/story/:id/viewers`

**Response**:

```json
{
  "success": true,
  "viewers": [
    {
      "user_id": 5,
      "viewed_at": "2025-12-23 10:30:00"
    }
  ],
  "count": 15
}
```

---

## Características Especiales

### Expiración Automática (24 horas)

- Las stories se marcan automáticamente como eliminadas después de 24 horas
- Solo se muestran stories creadas en las últimas 24 horas
- Método `deleteExpiredStories()` debe ejecutarse vía cron job

### Tipos de Story

- `image`: Historia con imagen
- `video`: Historia con video (incluye thumbnail)

### Permisos

- Solo el propietario puede eliminar su propia historia
- Todos pueden ver stories de usuarios que siguen
- Las vistas se registran automáticamente

---

## Notas Técnicas

- Las stories eliminadas se marcan con `is_delete = 1` (soft delete)
- El campo `has_viewed` indica si el usuario actual ya vio la story
- El campo `has_unviewed` indica si el usuario tiene stories sin ver
- Las stories se agrupan por usuario en el feed
- El contador de vistas es en tiempo real
