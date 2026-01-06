class NotificationModel {
  final int id;
  final int userId;
  final String type; // 'follow', 'like', 'comment'
  final int? relatedId; // postId, etc.
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? userImage;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    this.relatedId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.userImage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      type: json['type'] as String,
      relatedId: json['related_id'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      createdAt: DateTime.parse(json['created_at'] as String),
      userImage: json['user_image'],
    );
  }
}
