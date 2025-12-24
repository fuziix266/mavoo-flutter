import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostRepository {
  final String baseUrl;

  PostRepository({required this.baseUrl});

  Future<List<Post>> getFeed({int page = 1, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/post/feed?page=$page&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> postsJson = data['posts'] as List;
          return postsJson.map((json) => Post.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching feed: $e');
      return [];
    }
  }

  Future<bool> createPost(String text, {String? location, String type = 'text'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/post/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': text,
          'location': location,
          'post_type': type,
          // TODO: Add image/video logic
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/content/post/delete/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}
