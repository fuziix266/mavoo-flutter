class StravaActivity {
  final int id;
  final String name;
  final String type; // Run, Ride, Swim, etc.
  final DateTime startDate;
  final double distance; // meters
  final int movingTime; // seconds
  final double? averageSpeed;
  final double? maxSpeed;
  final double? totalElevationGain;

  StravaActivity({
    required this.id,
    required this.name,
    required this.type,
    required this.startDate,
    required this.distance,
    required this.movingTime,
    this.averageSpeed,
    this.maxSpeed,
    this.totalElevationGain,
  });

  factory StravaActivity.fromJson(Map<String, dynamic> json) {
    return StravaActivity(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      type: json['type'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      distance: (json['distance'] as num).toDouble(),
      movingTime: int.parse(json['moving_time'].toString()),
      averageSpeed: json['average_speed'] != null 
          ? (json['average_speed'] as num).toDouble() 
          : null,
      maxSpeed: json['max_speed'] != null 
          ? (json['max_speed'] as num).toDouble() 
          : null,
      totalElevationGain: json['total_elevation_gain'] != null 
          ? (json['total_elevation_gain'] as num).toDouble() 
          : null,
    );
  }

  String get distanceKm => (distance / 1000).toStringAsFixed(2);
  
  String get durationFormatted {
    final hours = movingTime ~/ 3600;
    final minutes = (movingTime % 3600) ~/ 60;
    final seconds = movingTime % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }
}
