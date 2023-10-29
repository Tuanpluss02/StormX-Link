import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_shortener_flutter/const_value.dart';
import 'package:url_shortener_flutter/models/user.dart';
import 'package:url_shortener_flutter/utils/secure_storage_method.dart';

import 'secure_storage_repository.dart';

class AuthRepository {
  Future<dynamic> createAccount(
    String username,
    String password,
  ) async {
    late  Response response;
    try {
      response = await  Dio().post(
        '$apiDomain/auth/register',
        data: {
          'username': username,
          'password': password,
        },
        options:  Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json'
          },
        ),
      );
      debugPrint(response.data.toString());
    } on  DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode != 200) return null;
    final token = response.data['access_token'];
    SecureStorageRepository().setAccessToken(token);
    final User user = await getUser(token);
    return user;
  }

  Future<dynamic> signIn(
    String username,
    String password,
  ) async {
    late  Response response;
    try {
      response = await  Dio().post(
        '$apiDomain/auth/token',
        data: {
          'username': username,
          'password': password,
        },
        options:  Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'accept': 'application/json'
          },
        ),
      );
    } on  DioError catch (e) {
      debugPrint(e.toString());
      return null;
    }
    if (response.statusCode != 200) return null;
    final token = response.data['access_token'];
    writeStorage('token', token);
    final User user = await getUser(token);
    return user;
  }

  Future<void> signOut() async {
    deleteAllStorage();
  }

    Future<dynamic> getUser(String token) async {
    late  Response response;
    try {
      response = await  Dio().get('$apiDomain/auth/verify',
          options:  Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on  DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode != 200) {
      return null;
    }
    return User.fromJson(response.data);
  }
}
