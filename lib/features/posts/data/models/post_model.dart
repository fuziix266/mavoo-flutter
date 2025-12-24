class Post {
  final int id;
  final int userId;
  final String text;
  final String? location;
  final String postType; // 'text', 'image', 'video'
  final DateTime createdAt;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final List<String> images;
  final List<String> videos;
  // User Data
  final String? username;
  final String? userFirstName;
  final String? userLastName;
  final String? userProfilePic;

  Post({
    required this.id,
    required this.userId,
    required this.text,
    this.location,
    required this.postType,
    required this.createdAt,
    this.isLiked = false,
    this.likeCount = 0,
    this.commentCount = 0,
    this.images = const [],
    this.videos = const [],
    this.username,
    this.userFirstName,
    this.userLastName,
    this.userProfilePic,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post_id'] as int,
      userId: json['user_id'] as int,
      text: json['text'] as String,
      location: json['location'] as String?,
      postType: json['post_type'] as String? ?? 'text',
      createdAt: DateTime.parse(json['created_at'] as String),
      isLiked: json['is_liked'] as bool? ?? false,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      videos: (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      // User Data
      username: json['username'] as String?,
      userFirstName: json['user_first_name'] as String?,
      userLastName: json['user_last_name'] as String?,
      userProfilePic: json['user_profile_pic'] as String?,
    );
  }
}
