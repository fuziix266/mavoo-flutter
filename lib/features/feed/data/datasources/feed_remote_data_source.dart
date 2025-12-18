import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient apiClient;

  FeedRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.posts);

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['posts'] == null) {
          return [];
        }

        final List<dynamic> postsJson = data['posts'];
        return postsJson.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(response.data['message'] ?? 'Server Error');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.message ?? 'Network Error');
    }
  }
}
