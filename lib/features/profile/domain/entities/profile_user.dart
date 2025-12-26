import 'package:equatable/equatable.dart';

class ProfileUser extends Equatable {
  final int id;
  final String username;
  final String? fullName;
  final String? bio;
  final String? profilePic;
  final String? coverPic;
  final int followersCount;
  final int followingCount;
  final int postCount;
  final bool isFollowing;

  const ProfileUser({
    required this.id,
    required this.username,
    this.fullName,
    this.bio,
    this.profilePic,
    this.coverPic,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postCount = 0,
    this.isFollowing = false,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        fullName,
        bio,
        profilePic,
        coverPic,
        followersCount,
        followingCount,
        postCount,
        isFollowing,
      ];
}
