import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final int id;
  final String text;
  final String type; // 'like', 'comment', 'follow'
  final String? fromUser;
  final String? fromUserPic;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.text,
    required this.type,
    this.fromUser,
    this.fromUserPic,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      fromUser: json['from_user'],
      fromUserPic: json['from_user_pic'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [id, text, type, fromUser, fromUserPic, isRead, createdAt];
}
