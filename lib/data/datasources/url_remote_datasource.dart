import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../common/constant.dart';
import '../../utils/shared_pref.dart';
import '../models/url_model.dart';

abstract class IUrlRemoteDataSource {
  Future<UrlModel> createUrl(String longUrl, String? urlCode);
  Future<List<UrlModel>> getUrls();
  Future<UrlModel> updateUrl(String? id, String? newLongUrl, String? newUrlCode);
  Future<void> deleteUrl(String? id);
}

@Injectable(as: IUrlRemoteDataSource)
class UrlRemoteDataSource implements IUrlRemoteDataSource {
  final Dio _dio;

  UrlRemoteDataSource(this._dio);

  @override
  Future<UrlModel> createUrl(String longUrl, String? urlCode) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _dio.post(
        "$apiUrl/create",
        data: {
          'longUrl': longUrl,
          'urlCode': urlCode,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(response.data['message']);
      }
      return UrlModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<UrlModel>> getUrls() async {
    try {
      final accessToken = await getAccessToken();
      final response = await _dio.get(
        "$apiUrl/getAll",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final List<UrlModel> urls = [];
      for (final url in response.data['data']) {
        urls.add(UrlModel.fromJson(url));
      }
      return urls;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UrlModel> updateUrl(String? id, String? newLongUrl, String? newUrlCode) async {
    try {
      final accessToken = await getAccessToken();
      final response = await _dio.put(
        "$apiUrl/update/$id",
        data: {
          "newLongUrl": newLongUrl,
          "newUrlCode": newUrlCode,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return UrlModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteUrl(String? id) async {
    try {
      final accessToken = await getAccessToken();
      await _dio.delete(
        "$apiUrl/delete/$id",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}