import 'package:dio/dio.dart';
import '../../../../core/utils/api_client.dart';
import '../models/event_model.dart';

class EventRepository {
  final ApiClient apiClient;

  EventRepository({required this.apiClient});

  Future<List<Event>> getUpcomingEvents() async {
    try {
      final response = await apiClient.dio.get('/content/event/upcoming');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> eventsJson = data['events'] as List;
          return eventsJson.map((json) => Event.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<Event?> getEventById(int eventId) async {
    try {
      final response = await apiClient.dio.get('/content/event/$eventId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return Event.fromJson(data['event']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching event details: $e');
      return null;
    }
  }

  Future<bool> registerForEvent(int eventId, String userId) async {
    try {
      final response = await apiClient.dio.post(
        '/content/event/$eventId/register',
        data: {'user_id': int.tryParse(userId) ?? userId},
      );

      if (response.statusCode == 200) {
        return response.data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error registering for event: $e');
      return false;
    }
  }

  Future<bool> unregisterFromEvent(int eventId, String userId) async {
    try {
      final response = await apiClient.dio.post(
        '/content/event/$eventId/unregister',
        data: {'user_id': int.tryParse(userId) ?? userId},
      );

      if (response.statusCode == 200) {
        return response.data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error unregistering from event: $e');
      return false;
    }
  }
}
