class ChatModel {
  final int id;
  final int userId;
  final String username;
  final String userProfilePic;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfilePic,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['chat_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? 'User',
      userProfilePic: json['profile_pic'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] != null ? DateTime.parse(json['last_message_time']) : DateTime.now(),
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class MessageModel {
  final int id;
  final int senderId;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      text: json['message'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
