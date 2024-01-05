import 'package:dio/dio.dart';
import 'package:url_shortener_flutter/utils/shared_pref.dart';

import '../common/constant.dart';
import '../models/url_model.dart';

class UrlRepository {
  List<Url> urls = [];
  final dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
    ),
  );
  Future<Url> createUrl(String longUrl, String? urlCode) async {
    try {
      final accessToken = await getAccessToken();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.post(
        "/create",
        data: {
          'longUrl': longUrl,
          'urlCode': urlCode,
        },
      );
      return Url.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Url>> getUrls() async {
    try {
      final accessToken = await getAccessToken();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get(
        "/getAll",
      );
      final List<Url> urls = [];
      for (final url in response.data['data']) {
        urls.add(Url.fromJson(url));
      }
      return urls;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Url> updateUrl(
      String? id, String? newLongUrl, String? newUrlCode) async {
    try {
      final accessToken = await getAccessToken();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.put(
        "/update/$id",
        data: {
          "newLongUrl": newLongUrl,
          "newUrlCode": newUrlCode,
        },
      );
      return Url.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteUrl(String? id) async {
    try {
      final accessToken = await getAccessToken();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      await dio.delete(
        "/delete/$id",
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
