import 'package:dio/dio.dart';

import '../common/constant.dart';

class AuthRepository {
  Future<void> createAccount(String username, String password) {
    try {
      final dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      return dio.post(
        "$apiAuthUrl/register",
        data: {
          'username': username,
          'password': password,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String username, String password) {
    try {
      final dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      return dio.post(
        "$apiAuthUrl/login",
        data: {
          'username': username,
          'password': password,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
