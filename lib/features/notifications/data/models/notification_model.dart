class NotificationModel {
  final int id;
  final String type; // 'like', 'follow', 'comment', 'message'
  final int userId;
  final String username;
  final String userProfilePic;
  final String? message;
  final int? postId;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    this.message,
    this.postId,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      type: json['type'] ?? 'unknown',
      userId: json['from_user_id'] is int ? json['from_user_id'] : int.tryParse(json['from_user_id'].toString()) ?? 0,
      username: json['from_username'] ?? 'User',
      userProfilePic: json['from_user_pic'] ?? '',
      message: json['text'],
      postId: json['post_id'] != null ? (json['post_id'] is int ? json['post_id'] : int.tryParse(json['post_id'].toString())) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
    );
  }
}
