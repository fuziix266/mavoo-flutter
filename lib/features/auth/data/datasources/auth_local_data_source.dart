import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastUser();
  Future<void> clearCache();
}

const CACHED_TOKEN = 'CACHED_TOKEN';
const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(CACHED_TOKEN, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(CACHED_TOKEN);
  }

  @override
  Future<void> cacheUser(UserModel user) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getLastUser() async {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      try {
        return UserModel.fromJson(json.decode(jsonString));
      } catch (e) {
        throw CacheFailure('Error decoding cached user: $e');
      }
    } else {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(CACHED_TOKEN);
    await sharedPreferences.remove(CACHED_USER);
  }
}
