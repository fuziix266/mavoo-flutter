import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.username,
    super.fullName,
    super.profileImage,
    super.token,
    super.bio,
    super.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Combine first_name and last_name to create fullName
    final firstName = json['first_name'] ?? '';
    final lastName = json['last_name'] ?? '';
    final fullName = '$firstName $lastName'.trim();

    print('[UserModel] Parsing user data:');
    print('[UserModel] first_name: $firstName');
    print('[UserModel] last_name: $lastName');
    print('[UserModel] fullName: $fullName');
    print('[UserModel] username: ${json['username']}');
    print('[UserModel] id: ${json['id']}');

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? json['display_name'],
      fullName:
          fullName.isNotEmpty ? fullName : (json['full_name'] ?? json['name']),
      profileImage:
          json['profile_pic'] ?? json['profile_image'] ?? json['avatar'],
      token: json['token'],
      bio: json['bio'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'full_name': fullName,
      'profile_image': profileImage,
      'token': token,
      'bio': bio,
      'website': website,
    };
  }
}
