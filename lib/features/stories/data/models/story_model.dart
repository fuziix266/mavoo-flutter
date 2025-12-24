class Story {
  final int storyId;
  final int userId;
  final String url;
  final String? videoThumbnail;
  final String? location;
  final String? text;
  final String type; // 'image' or 'video'
  final DateTime createdAt;
  final bool hasViewed;

  Story({
    required this.storyId,
    required this.userId,
    required this.url,
    this.videoThumbnail,
    this.location,
    this.text,
    required this.type,
    required this.createdAt,
    this.hasViewed = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now();
    } catch (e) {
      print('Error parsing date: ${json['created_at']}, error: $e');
      parsedDate = DateTime.now();
    }

    return Story(
      storyId: int.parse(json['story_id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      url: json['url'] as String,
      videoThumbnail: json['video_thumbnail'] as String?,
      location: json['location'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String,
      createdAt: parsedDate,
      hasViewed: (json['is_viewed'] ?? 0) == 1,
    );
  }
}

class UserStories {
  final int userId;
  final List<Story> stories;
  final bool hasUnviewed;

  UserStories({
    required this.userId,
    required this.stories,
    required this.hasUnviewed,
  });

  factory UserStories.fromJson(Map<String, dynamic> json) {
    return UserStories(
      userId: json['user_id'] as int,
      stories: (json['stories'] as List)
          .map((s) => Story.fromJson(s))
          .toList(),
      hasUnviewed: json['has_unviewed'] as bool,
    );
  }
}
