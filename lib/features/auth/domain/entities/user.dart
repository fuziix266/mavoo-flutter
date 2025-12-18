import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? profileImage;
  final String? token;

  const User({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.profileImage,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, username, fullName, profileImage, token];
}
