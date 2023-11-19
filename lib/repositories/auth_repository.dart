import 'package:dio/dio.dart';

import '../common/constant.dart';

class AuthRepository {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiAuthUrl,
      contentType: 'application/json',
    ),
  );
  Future<Response> createAccount(String username, String password) async {
    try {
      final response = await dio.post(
        "/register",
        data: {
          'username': username,
          'password': password,
        },
      );

      return response;
    } catch (e) {
      throw Exception('Lỗi khi tạo tài khoản: $e');
    }
  }

  Future<Response> login(String username, String password) async {
    try {
      final response = await dio.post(
        "/login",
        data: {
          'username': username,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Lỗi khi đăng nhập: $e');
    }
  }
}
