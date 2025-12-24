import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story_user_model.dart';

class StoryRepository {
  final String baseUrl;

  StoryRepository({required this.baseUrl});

  Future<List<StoryUser>> getStoriesBar(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/story/bar?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final users = (data['data'] as List)
              .map((user) => StoryUser.fromJson(user))
              .toList();
          return users;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching stories bar: $e');
      return [];
    }
  }
}
