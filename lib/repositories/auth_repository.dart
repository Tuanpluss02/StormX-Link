import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_shortener_flutter/utils/shared_pref.dart';

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
      final token = response.data['data']['accessToken'] as String;
      setAccessToken(token);
      return response;
    } catch (e) {
      throw Exception(e.toString());
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
      final token = response.data['data']['accessToken'] as String;
      setAccessToken(token);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
