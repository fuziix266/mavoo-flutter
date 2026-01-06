import 'package:dio/dio.dart';
import '../../../../core/utils/api_client.dart';
import '../models/chat_model.dart';

class MessageRepository {
  final ApiClient apiClient;

  MessageRepository({required this.apiClient});

  Future<List<ChatModel>> getChats() async {
    try {
      final response = await apiClient.dio.get('/content/messages/chats');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['response_code'] == '1' && data['chats'] != null) {
          final List<dynamic> list = data['chats'];
          return list.map((e) => ChatModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }

  Future<List<MessageModel>> getMessages(int chatId) async {
    try {
      final response = await apiClient.dio.get('/content/messages/chat/$chatId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['response_code'] == '1' && data['messages'] != null) {
          final List<dynamic> list = data['messages'];
          return list.map((e) => MessageModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
}
