import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/constant.dart';

class AuthRepository {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiAuthUrl,
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
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
      debugPrint(response.toString());
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
      debugPrint(response.toString());
      return response;
    } catch (e) {
      throw Exception('Lỗi khi đăng nhập: $e');
    }
  }
}
