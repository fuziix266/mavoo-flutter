class FriendStats {
  final int userId;
  final String username;
  final String fullName;
  final String? profilePic;
  final FriendActivityStats stats;

  FriendStats({
    required this.userId,
    required this.username,
    required this.fullName,
    this.profilePic,
    required this.stats,
  });

  factory FriendStats.fromJson(Map<String, dynamic> json) {
    return FriendStats(
      userId: json['user_id'] as int,
      username: json['username'] as String,
      fullName: json['full_name'] as String,
      profilePic: json['profile_pic'] as String?,
      stats:
          FriendActivityStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'profile_pic': profilePic,
      'stats': stats.toJson(),
    };
  }
}

class FriendActivityStats {
  final double totalDistanceWeek;
  final int totalActivitiesWeek;
  final String? lastActivityDate;
  final String? lastActivityType;

  FriendActivityStats({
    required this.totalDistanceWeek,
    required this.totalActivitiesWeek,
    this.lastActivityDate,
    this.lastActivityType,
  });

  factory FriendActivityStats.fromJson(Map<String, dynamic> json) {
    return FriendActivityStats(
      totalDistanceWeek:
          (json['total_distance_week'] as num?)?.toDouble() ?? 0.0,
      totalActivitiesWeek: json['total_activities_week'] as int? ?? 0,
      lastActivityDate: json['last_activity_date'] as String?,
      lastActivityType: json['last_activity_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_distance_week': totalDistanceWeek,
      'total_activities_week': totalActivitiesWeek,
      'last_activity_date': lastActivityDate,
      'last_activity_type': lastActivityType,
    };
  }
}
