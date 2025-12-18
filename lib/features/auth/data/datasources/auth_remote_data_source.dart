import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/api_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String username, String fullName);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Verificar si hay un error lógico en la respuesta exitosa
        if (data['status'] != null && data['status'] != 200) {
           throw ServerFailure(data['message'] ?? data['error'] ?? 'Authentication Failed');
        }
        
        if (data['user'] == null) {
          throw ServerFailure(data['message'] ?? 'User data missing');
        }

        // El backend devuelve: {status: 200, message: "...", token: "...", user: {...}}
        // Combinamos user + token
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(data['user']);
        userMap['token'] = data['token']; 
        return UserModel.fromJson(userMap);
      } else {
        throw ServerFailure(response.data['message'] ?? response.data['error'] ?? 'Server Error');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['message'] ?? e.response?.data['error'] ?? e.message ?? 'Network Error');
    }
  }

  @override
  Future<UserModel> register(String email, String password, String username, String fullName) async {
    try {
      // Separamos fullName en first y last name de manera simple
      final names = fullName.split(' ');
      final firstName = names.isNotEmpty ? names.first : '';
      final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

      final response = await apiClient.dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      if (response.statusCode == 201) {
        // En registro usualmente devolvemos el usuario creado O hacemos login automático.
        // El backend actual solo devuelve mensaje de éxito.
        // Para simplificar, podríamos retornar un UserModel "dummy" o requerir login.
        // Por ahora retornamos un modelo básico.
        return UserModel(
          id: '0', 
          email: email, 
          username: username,
          fullName: fullName,
        );
      } else {
        throw ServerFailure(response.data['error'] ?? 'Server Error');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.response?.data['error'] ?? e.message);
    }
  }
}
