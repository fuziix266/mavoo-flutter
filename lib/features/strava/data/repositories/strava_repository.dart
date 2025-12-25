import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/strava_athlete_model.dart';
import '../models/strava_activity_model.dart';

class StravaRepository {
  final String baseUrl;

  StravaRepository({required this.baseUrl});

  /// Get OAuth authorization URL
  Future<String?> getAuthorizationUrl(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/strava/auth-url')
          .replace(queryParameters: {'user_id': userId.toString()});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['response_code'] == '1') {
          return data['url'] as String;
        }
      }

      return null;
    } catch (e) {
      print('Error getting auth URL: $e');
      return null;
    }
  }

  /// Exchange authorization code for tokens
  Future<StravaAthlete?> exchangeCode(String code, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/strava/exchange'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['response_code'] == '1' && data['athlete'] != null) {
          return StravaAthlete.fromJson(data['athlete'] as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      print('Error exchanging code: $e');
      return null;
    }
  }

  /// Get athlete info
  Future<Map<String, dynamic>?> getAthlete(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/strava/athlete')
          .replace(queryParameters: {'user_id': userId.toString()});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['response_code'] == '1') {
          return {
            'connected': data['connected'] as bool,
            'athlete': data['athlete'] != null 
                ? StravaAthlete.fromJson(data['athlete'] as Map<String, dynamic>)
                : null,
            'last_sync': data['last_sync'] as String?,
          };
        }
      }

      return {'connected': false, 'athlete': null};
    } catch (e) {
      print('Error getting athlete: $e');
      return {'connected': false, 'athlete': null};
    }
  }

  /// Get recent activities
  Future<List<StravaActivity>> getActivities(int userId, {int page = 1, int perPage = 30}) async {
    try {
      final uri = Uri.parse('$baseUrl/strava/activities')
          .replace(queryParameters: {
            'user_id': userId.toString(),
            'page': page.toString(),
            'per_page': perPage.toString(),
          });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['response_code'] == '1') {
          final List<dynamic> activitiesJson = data['activities'] ?? [];
          return activitiesJson
              .map((item) => StravaActivity.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error getting activities: $e');
      return [];
    }
  }

  /// Disconnect Strava
  Future<bool> disconnect(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/strava/disconnect')
          .replace(queryParameters: {'user_id': userId.toString()});

      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response_code'] == '1';
      }

      return false;
    } catch (e) {
      print('Error disconnecting: $e');
      return false;
    }
  }

  /// Refresh access token
  Future<bool> refreshToken(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/strava/refresh')
          .replace(queryParameters: {'user_id': userId.toString()});

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response_code'] == '1';
      }

      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }
}
