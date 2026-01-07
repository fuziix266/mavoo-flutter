import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? profileImage;
  final String? token;
  final String? bio;
  final String? website;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.profileImage,
    this.token,
    this.bio,
    this.website,
  });

  @override
  List<Object?> get props =>
      [id, email, username, fullName, profileImage, token, bio, website];
}
