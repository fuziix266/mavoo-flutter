import '../../domain/entities/profile_user.dart';

class ProfileUserModel extends ProfileUser {
  const ProfileUserModel({
    required int id,
    required String username,
    String? fullName,
    String? bio,
    String? profilePic,
    String? coverPic,
    int followersCount = 0,
    int followingCount = 0,
    int postCount = 0,
    bool isFollowing = false,
  }) : super(
          id: id,
          username: username,
          fullName: fullName,
          bio: bio,
          profilePic: profilePic,
          coverPic: coverPic,
          followersCount: followersCount,
          followingCount: followingCount,
          postCount: postCount,
          isFollowing: isFollowing,
        );

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'],
      bio: json['bio'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postCount: json['post_count'] ?? 0,
      isFollowing: json['is_following'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'bio': bio,
      'profile_pic': profilePic,
      'cover_pic': coverPic,
      'followers_count': followersCount,
      'following_count': followingCount,
      'post_count': postCount,
      'is_following': isFollowing,
    };
  }
}
