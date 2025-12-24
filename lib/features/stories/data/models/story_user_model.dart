class StoryUser {
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePic;
  final int storyCount;
  final bool hasUnviewed;
  final DateTime latestStoryTime;

  StoryUser({
    required this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePic,
    required this.storyCount,
    required this.hasUnviewed,
    required this.latestStoryTime,
  });

  factory StoryUser.fromJson(Map<String, dynamic> json) {
    return StoryUser(
      userId: int.parse(json['user_id'].toString()),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      username: json['username'] as String?,
      profilePic: json['profile_pic'] as String?,
      storyCount: json['total_stories'] as int,
      hasUnviewed: json['has_unviewed'] as bool,
      latestStoryTime: DateTime.now(), // API doesn't return this anymore, use current time
    );
  }

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return username ?? 'Usuario';
  }
}
