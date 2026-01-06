import 'package:dio/dio.dart';
import '../../../../core/utils/api_client.dart';
import '../models/search_history_model.dart';
import '../models/search_results_model.dart';

class SearchRepository {
  final ApiClient apiClient;

  SearchRepository({required this.apiClient});

  /// Unified search across multiple types
  Future<SearchResults> search(String query, SearchType type) async {
    try {
      final response = await apiClient.dio.post(
        '/content/search/query',
        data: {
          'user_id': 1, // TODO: Get from auth
          'query': query,
          'type': _searchTypeToString(type),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['response_code'] == '1') {
          return SearchResults.fromJson(data);
        }
      }

      return SearchResults(people: [], events: []);
    } catch (e) {
      print('Error searching: $e');
      return SearchResults(people: [], events: []);
    }
  }

  /// Get search history for user
  Future<List<SearchHistory>> getHistory({
    SearchType? type,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.dio.get(
        '/content/search/history',
        queryParameters: {
          'user_id': 1, // TODO: Get from auth
          'type': type != null ? _searchTypeToString(type) : 'all',
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['response_code'] == '1') {
          final List<dynamic> historyJson = data['history'] ?? [];
          return historyJson
              .map((item) => SearchHistory.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error getting history: $e');
      return [];
    }
  }

  /// Add search to history
  Future<void> addToHistory(
    String query,
    SearchType type, {
    int? resultId,
    ResultType? resultType,
    int resultsCount = 0,
  }) async {
    try {
      await apiClient.dio.post(
        '/content/search/history/add',
        data: {
          'user_id': 1, // TODO: Get from auth
          'query': query,
          'type': _searchTypeToString(type),
          if (resultId != null) 'result_id': resultId,
          if (resultType != null) 'result_type': _resultTypeToString(resultType),
          'results_count': resultsCount,
        },
      );
    } catch (e) {
      print('Error adding to history: $e');
    }
  }

  /// Delete specific search history item (soft delete)
  Future<bool> deleteHistory(int historyId) async {
    try {
      final response = await apiClient.dio.delete(
        '/content/search/history/$historyId',
        queryParameters: {'user_id': 1}, // TODO: Get from auth
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['response_code'] == '1';
      }

      return false;
    } catch (e) {
      print('Error deleting history: $e');
      return false;
    }
  }

  /// Clear all history (soft delete)
  Future<bool> clearHistory({SearchType? type}) async {
    try {
      final response = await apiClient.dio.delete(
        '/content/search/history/clear',
        queryParameters: {
          'user_id': 1, // TODO: Get from auth
          'type': type != null ? _searchTypeToString(type) : 'all',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['response_code'] == '1';
      }

      return false;
    } catch (e) {
      print('Error clearing history: $e');
      return false;
    }
  }

  String _searchTypeToString(SearchType type) {
    switch (type) {
      case SearchType.people:
        return 'people';
      case SearchType.events:
        return 'events';
      case SearchType.hashtags:
        return 'hashtags';
      case SearchType.posts:
        return 'posts';
      case SearchType.groups:
        return 'groups';
      case SearchType.all:
        return 'all';
    }
  }

  String _resultTypeToString(ResultType type) {
    switch (type) {
      case ResultType.user:
        return 'user';
      case ResultType.event:
        return 'event';
      case ResultType.hashtag:
        return 'hashtag';
      case ResultType.post:
        return 'post';
      case ResultType.group:
        return 'group';
    }
  }
}
