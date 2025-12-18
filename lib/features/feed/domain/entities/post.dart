import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String text;
  final String? imageUrl;
  final String? videoUrl;
  final String userId;
  final String? username;
  final String? userProfileImage;
  final String createdAt;
  final int likesCount;
  final int commentsCount;

  const Post({
    required this.id,
    required this.text,
    this.imageUrl,
    this.videoUrl,
    required this.userId,
    this.username,
    this.userProfileImage,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  @override
  List<Object?> get props => [id, text, imageUrl, videoUrl, userId, createdAt];
}
