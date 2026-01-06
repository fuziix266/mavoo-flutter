import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              // Force Host header just in case DNS resolution maps to IP but server requires Host
              // 'Host': 'retrobox.cl', // Only needed if we were using IP in baseUrl, but we are using domain.
              // However, user instruction said: "Si el DNS aún no propaga, asegúrate de que el ApiClient maneje el header Host"
              // Adding it explicitly is safe.
              'Host': 'retrobox.cl',
            },
            // Allow self-signed certs for retrobox.cl if needed (since curl -k was used)
            validateStatus: (status) {
               return status != null && status < 500;
            }
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          // Aquí se puede agregar el token JWT si existe
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            print('Message: ${e.message}');
            print('Error: ${e.error}');
            print('Type: ${e.type}');
            print('Response Data: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }
}
