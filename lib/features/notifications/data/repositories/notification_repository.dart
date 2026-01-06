import 'package:dio/dio.dart';
import '../../../../core/utils/api_client.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient apiClient;

  NotificationRepository({required this.apiClient});

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await apiClient.dio.get('/content/notifications'); // Assuming endpoint

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['response_code'] == '1' && data['notifications'] != null) {
          final List<dynamic> list = data['notifications'];
          return list.map((e) => NotificationModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }
}
