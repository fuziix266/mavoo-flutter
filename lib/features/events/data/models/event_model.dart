class Event {
  final int id;
  final String name;
  final String description;
  final String sport;
  final DateTime eventDate;
  final String? location;
  final int? maxParticipants;
  final int currentParticipants;
  final int? organizerId;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.eventDate,
    this.location,
    this.maxParticipants,
    required this.currentParticipants,
    this.organizerId,
    this.imageUrl,
    required this.status,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      sport: json['sport'] as String,
      eventDate: DateTime.parse(json['event_date'] as String),
      location: json['location'] as String?,
      maxParticipants: json['max_participants'] as int?,
      currentParticipants: json['current_participants'] as int? ?? 0,
      organizerId: json['organizer_id'] as int?,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sport': sport,
      'event_date': eventDate.toIso8601String(),
      'location': location,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'organizer_id': organizerId,
      'image_url': imageUrl,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isFull => maxParticipants != null && currentParticipants >= maxParticipants!;
  
  int get availableSpots => maxParticipants != null 
      ? maxParticipants! - currentParticipants 
      : 999;
}
