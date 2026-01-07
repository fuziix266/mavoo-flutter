import 'package:dio/dio.dart';
import '../../../../core/utils/api_client.dart';
import '../models/post_model.dart';

class PostRepository {
  final ApiClient apiClient;

  PostRepository({required this.apiClient});

  Future<List<Post>> getFeed({int page = 1, int limit = 20}) async {
    try {
      final response = await apiClient.dio.get(
        '/content/post/feed',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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

  Future<bool> createPost(String text,
      {String? location, String type = 'text', String? mediaPath}) async {
    try {
      dynamic data;

      if (mediaPath != null) {
        data = FormData.fromMap({
          'text': text,
          'location': location,
          'post_type': type,
          'file': await MultipartFile.fromFile(mediaPath),
        });
      } else {
        data = {
          'text': text,
          'location': location,
          'post_type': type,
        };
      }

      final response = await apiClient.dio.post(
        '/content/post/create',
        data: data,
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
      final response = await apiClient.dio.delete(
        '/content/post/delete/$id',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}
