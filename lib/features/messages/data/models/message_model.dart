class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final bool isMine; // Helper for UI

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.createdAt,
    required this.isRead,
    this.isMine = false,
  });

  factory Message.fromJson(Map<String, dynamic> json, int currentUserId) {
    return Message(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] == 1 || json['is_read'] == true,
      isMine: (json['sender_id'] as int) == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}

class Conversation {
  final int id;
  final int userId;
  final String userName;
  final String userImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userImage: json['user_image'] ?? '',
      lastMessage: json['last_message'] as String,
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}
