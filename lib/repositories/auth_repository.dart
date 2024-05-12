import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:link/utils/shared_pref.dart';

import '../common/constant.dart';

class AuthRepository {
  final dio = Dio(
    BaseOptions(
      headers: {
        'Allow-Control-Allow-Origin': '*',
      },
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
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
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkUserLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
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
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }
}
