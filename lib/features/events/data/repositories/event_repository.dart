import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';

class EventRepository {
  final String baseUrl;

  EventRepository({required this.baseUrl});

  Future<List<Event>> getUpcomingEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/event/upcoming'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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

  Future<bool> registerForEvent(int eventId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/event/$eventId/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error registering for event: $e');
      return false;
    }
  }

  Future<bool> unregisterFromEvent(int eventId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/event/$eventId/unregister'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error unregistering from event: $e');
      return false;
    }
  }
}
