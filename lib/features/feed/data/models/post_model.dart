import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.text,
    super.imageUrl,
    super.videoUrl,
    required super.userId,
    super.username,
    super.userProfileImage,
    required super.createdAt,
    super.likesCount,
    super.commentsCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '0',
      text: json['text'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      userId: json['user_id']?.toString() ?? '0',
      username: json['username'],
      userProfileImage: json['user_profile_image'],
      createdAt: json['created_at'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'user_id': userId,
      'username': username,
      'user_profile_image': userProfileImage,
      'created_at': createdAt,
      'likes_count': likesCount,
      'comments_count': commentsCount,
    };
  }
}
