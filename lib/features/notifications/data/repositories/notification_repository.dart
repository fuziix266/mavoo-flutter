import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_item.dart';

class NotificationRepository {
  final String baseUrl;
  final http.Client client;

  NotificationRepository({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<List<NotificationItem>> getNotifications() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/notifications'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['notifications'] as List;
          return list.map((json) => NotificationItem.fromJson(json)).toList();
        }
      }
      // Mock data for fallback
      return List.generate(10, (index) => NotificationItem(
        id: index,
        text: 'liked your post',
        type: 'like',
        fromUser: 'User $index',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      ));
    } catch (e) {
      print('Error fetching notifications: $e');
       // Mock data for fallback
      return List.generate(10, (index) => NotificationItem(
        id: index,
        text: 'liked your post',
        type: 'like',
        fromUser: 'User $index',
        createdAt: DateTime.now().subtract(Duration(hours: index)),
      ));
    }
  }
}
