import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../const_value.dart';
import '../models/urls.dart';
import '../models/user.dart';
import 'secure_storage_repository.dart';

class UrlRepository {
  Future<void> deleteUrl(String shortname) async {
    String? accessToken = await SecureStorageRepository().getAccessToken();
    late  Response response;
    try {
      response = await  Dio().delete('$apiDomain/user/delete-url',
          queryParameters: {'short_name': shortname},
          options:  Options(headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }));
    } on Exception {
      return;
    }
    if (response.statusCode == 200) {
     
    } else {
  
    }
  }

  Future< Response> shortenUrl(String shortName, String longUrl) async {
    String? accessToken = await SecureStorageRepository().getAccessToken();
    late  Response response;
    try {
      response = await  Dio().post('$apiDomain/shorten',
          queryParameters: {
            'long_url': longUrl,
            'short_name': shortName,
          },
          options:  Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on  DioError catch (e) {
      debugPrint(e.toString());
      return e.response!;
    }
    return response;
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

  Future<List<Urls>> getRecentlyUrls() async {
    String? accessToken = await SecureStorageRepository().getAccessToken();
    late  Response response;
    try {
      response = await  Dio().get('$apiDomain/user/get_urls',
          options:  Options(
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer $accessToken'
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
    } on  DioError catch (e) {
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