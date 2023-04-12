import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:url_shortener_flutter/const_value.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/models/user.dart';
import 'package:url_shortener_flutter/services/storage.dart';

class Auth {
  Future<String> getAccessToken() async {
    String? accessToken = await readStorage('token');
    return accessToken ?? '';
  }

  Future<dynamic> signupRequest(
    String username,
    String password,
  ) async {
    late dio.Response response;
    try {
      response = await dio.Dio().post(
        '$apiDomain/auth/register',
        data: {
          'username': username,
          'password': password,
        },
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json'
          },
        ),
      );
      debugPrint(response.data.toString());
    } on dio.DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode != 200) return null;
    final token = response.data['access_token'];
    await writeStorage('token', token);
    debugPrint(response.data.toString());
    final User user = await getUser(token);
    return user;
  }

  Future<dynamic> loginRequest(
    String username,
    String password,
  ) async {
    late dio.Response response;
    try {
      response = await dio.Dio().post(
        '$apiDomain/auth/token',
        data: {
          'username': username,
          'password': password,
        },
        options: dio.Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'accept': 'application/json'
          },
        ),
      );
    } on dio.DioError catch (e) {
      debugPrint(e.toString());
      return null;
    }
    if (response.statusCode != 200) return null;
    final token = response.data['access_token'];
    await writeStorage('token', token);
    final User user = await getUser(token);
    return user;
  }

  Future<void> signOut() async {
    deleteAllStorage();
  }

  Future<void> deleteUrl(String shortname, void toRemove,
      VoidCallback onSuccess, VoidCallback onError) async {
    String accessToken = await getAccessToken();
    late dio.Response response;
    try {
      response = await dio.Dio().delete('$apiDomain/user/delete-url',
          queryParameters: {'short_name': shortname},
          options: dio.Options(headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
    } on Exception {
      onError.call();
    }
    if (response.statusCode == 200) {
      toRemove;
      onSuccess.call();
    } else {
      onError.call();
    }
  }

  Future<dio.Response> shortenUrl(String shortName, String longUrl) async {
    String accessToken = await getAccessToken();
    late dio.Response response;
    try {
      response = await dio.Dio().post('$apiDomain/shorten',
          queryParameters: {
            'long_url': longUrl,
            'short_name': shortName,
          },
          options: dio.Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on dio.DioError catch (e) {
      debugPrint(e.toString());
      return e.response!;
    }
    return response;
  }

  Future<dynamic> getUser(String token) async {
    late dio.Response response;
    try {
      response = await dio.Dio().get('$apiDomain/auth/verify',
          options: dio.Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on dio.DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode != 200) {
      return null;
    }
    return User.fromJson(response.data);
  }

  Future<List<Urls>> getRecentlyUrls() async {
    String accessToken = await getAccessToken();
    late dio.Response response;
    try {
      response = await dio.Dio().get('$apiDomain/user/get_urls',
          options: dio.Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on dio.DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode == 200) {
      var mapUrls = response.data['urls'] as List;
      var dataFetched = mapUrls.map((e) => Urls.fromJson(e)).toList();
      return dataFetched;
    }
    return [];
  }
}
