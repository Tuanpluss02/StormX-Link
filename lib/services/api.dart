import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_shortener_flutter/const_value.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/services/storage.dart';

class Auth {
  Future<String> getAccessToken() async {
    String? accessToken = await readStorage('token');
    return accessToken ?? '';
  }

  Future<bool> signupRequest(
    String username,
    String password,
  ) async {
    late dio.Response response;
    try {
      response = await dio.Dio().post(
        '$apiDomain/auth/register',
        // 'http://127.0.0.1:8000/api/register',
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
      return false;
    }
    if (response.statusCode != 200) return false;
    // deleteAllStorage();
    await writeStorage('token', response.data['access_token']);
    return true;
  }

  Future<bool> loginRequest(
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
      return false;
    }
    if (response.statusCode != 200) return false;
    // deleteAllStorage();
    await writeStorage('token', response.data['access_token']);
    return true;
  }

  Future<void> signOut() async {
    deleteAllStorage();
  }

  Future<void> deleteUrl(String shortname, Rx<List<Urls>> recentlyUrls,
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
      recentlyUrls.value
          .removeWhere((element) => element.shortname == shortname);
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
