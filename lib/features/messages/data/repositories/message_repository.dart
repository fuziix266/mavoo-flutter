import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepository {
  final ApiClient apiClient;

  MessageRepository({required this.apiClient});

  Future<Either<Failure, List<Conversation>>> getConversations() async {
    try {
      final response = await apiClient.get('/chat/conversations');
      final List<dynamic> data = response.data['data'] ?? [];
      final conversations = data.map((e) => Conversation.fromJson(e)).toList();
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Now requires currentUserId to determine 'isMine' correctly
  Future<Either<Failure, List<Message>>> getMessages(int conversationId, int currentUserId) async {
    try {
      final response = await apiClient.get('/chat/messages/$conversationId');
      final List<dynamic> data = response.data['data'] ?? [];

      final messages = data.map((e) => Message.fromJson(e, currentUserId)).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Backend infers sender from Token. We need currentUserId just for the return model parsing.
  Future<Either<Failure, Message>> sendMessage(int receiverId, String content, int currentUserId) async {
    try {
      final response = await apiClient.post('/chat/message', data: {
        'receiver_id': receiverId,
        'content': content,
      });
      final data = response.data['data'];
      return Right(Message.fromJson(data, currentUserId));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
