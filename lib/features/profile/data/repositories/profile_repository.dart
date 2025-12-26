import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_user_model.dart';

class ProfileRepository {
  final String baseUrl;
  final http.Client client;

  ProfileRepository({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<ProfileUserModel?> getProfile(int userId) async {
    try {
      // Endpoint assumption based on pattern
      final response = await client.get(
        Uri.parse('$baseUrl/users/profile/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['user'] != null) {
          return ProfileUserModel.fromJson(data['user']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  Future<ProfileUserModel?> getMyProfile() async {
     // TODO: Get ID from auth token or separate endpoint
     // For now using ID 1 as mock
     return getProfile(1);
  }
}
