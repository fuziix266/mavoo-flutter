import '../../../../core/utils/api_client.dart';
import '../models/story_user_model.dart';

class StoryRepository {
  final ApiClient apiClient;

  StoryRepository({required this.apiClient});

  Future<List<StoryUser>> getStoriesBar(int userId) async {
    try {
      final response = await apiClient.dio.get(
        '/content/story/bar',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
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
