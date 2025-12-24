import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_history_model.dart';
import '../models/search_results_model.dart';
import '../../../../core/services/api_service.dart';

class SearchRepository {
  final ApiService apiService;

  SearchRepository({required this.apiService});

  /// Unified search across multiple types
  Future<SearchResults> search(String query, SearchType type) async {
    try {
      final response = await apiService.post(
        '/content/search/query',
        body: {
          'user_id': 1, // TODO: Get from auth
          'query': query,
          'type': _searchTypeToString(type),
        },
      );

      if (response['response_code'] == '1') {
        return SearchResults.fromJson(response);
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
      final queryParams = {
        'user_id': '1', // TODO: Get from auth
        'type': type != null ? _searchTypeToString(type) : 'all',
        'limit': limit.toString(),
      };

      final response = await apiService.get(
        '/content/search/history',
        queryParameters: queryParams,
      );

      if (response['response_code'] == '1') {
        final List<dynamic> historyJson = response['history'] ?? [];
        return historyJson
            .map((item) => SearchHistory.fromJson(item as Map<String, dynamic>))
            .toList();
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
      await apiService.post(
        '/content/search/history/add',
        body: {
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
      final response = await apiService.delete(
        '/content/search/history/$historyId',
        queryParameters: {'user_id': '1'}, // TODO: Get from auth
      );

      return response['response_code'] == '1';
    } catch (e) {
      print('Error deleting history: $e');
      return false;
    }
  }

  /// Clear all history (soft delete)
  Future<bool> clearHistory({SearchType? type}) async {
    try {
      final queryParams = {
        'user_id': '1', // TODO: Get from auth
        'type': type != null ? _searchTypeToString(type) : 'all',
      };

      final response = await apiService.delete(
        '/content/search/history/clear',
        queryParameters: queryParams,
      );

      return response['response_code'] == '1';
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
