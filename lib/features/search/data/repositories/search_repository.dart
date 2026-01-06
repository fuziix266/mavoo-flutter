import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_history_model.dart';
import '../models/search_results_model.dart';

class SearchRepository {
  final String baseUrl;

  SearchRepository({required this.baseUrl});

  /// Unified search across multiple types
  Future<SearchResults> search(String userId, String query, SearchType type) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/search/query'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'query': query,
          'type': _searchTypeToString(type),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
  Future<List<SearchHistory>> getHistory(String userId, {
    SearchType? type,
    int limit = 10,
  }) async {
    try {
      final queryParams = {
        'user_id': userId,
        'type': type != null ? _searchTypeToString(type) : 'all',
        'limit': limit.toString(),
      };

      final uri = Uri.parse('$baseUrl/content/search/history')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
    String userId,
    String query,
    SearchType type, {
    int? resultId,
    ResultType? resultType,
    int resultsCount = 0,
  }) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/content/search/history/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'query': query,
          'type': _searchTypeToString(type),
          if (resultId != null) 'result_id': resultId,
          if (resultType != null) 'result_type': _resultTypeToString(resultType),
          'results_count': resultsCount,
        }),
      );
    } catch (e) {
      print('Error adding to history: $e');
    }
  }

  /// Delete specific search history item (soft delete)
  Future<bool> deleteHistory(String userId, int historyId) async {
    try {
      final uri = Uri.parse('$baseUrl/content/search/history/$historyId')
          .replace(queryParameters: {'user_id': userId});

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response_code'] == '1';
      }

      return false;
    } catch (e) {
      print('Error deleting history: $e');
      return false;
    }
  }

  /// Clear all history (soft delete)
  Future<bool> clearHistory(String userId, {SearchType? type}) async {
    try {
      final queryParams = {
        'user_id': userId,
        'type': type != null ? _searchTypeToString(type) : 'all',
      };

      final uri = Uri.parse('$baseUrl/content/search/history/clear')
          .replace(queryParameters: queryParams);

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
