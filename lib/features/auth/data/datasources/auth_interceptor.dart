import 'package:dio/dio.dart';
import 'auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  AuthInterceptor({required this.localDataSource});

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('[AuthInterceptor] Added token to request: ${options.path}');
    }
    super.onRequest(options, handler);
  }
}
