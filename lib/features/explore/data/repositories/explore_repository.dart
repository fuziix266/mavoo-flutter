import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../posts/data/models/post_model.dart';

class ExploreRepository {
  final String baseUrl;
  final http.Client client;

  ExploreRepository({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<List<Post>> getExploreContent() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/content/explore'),
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
      print('Error fetching explore content: $e');
      return [];
    }
  }
}
