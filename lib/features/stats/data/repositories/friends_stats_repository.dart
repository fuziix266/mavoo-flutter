import '../../../../core/utils/api_client.dart';
import '../models/friend_stats_model.dart';

class FriendsStatsRepository {
  final ApiClient apiClient;

  FriendsStatsRepository({required this.apiClient});

  Future<List<FriendStats>> getFriendsStats(String userId) async {
    try {
      final response = await apiClient.dio.get(
        '/follow/friends-stats',
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> friendsJson = response.data['friends'] as List;
        return friendsJson.map((json) => FriendStats.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching friends stats: $e');
      return [];
    }
  }
}
