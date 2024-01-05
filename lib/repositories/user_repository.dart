import 'package:dio/dio.dart';

import '../common/constant.dart';
import '../models/user_model.dart';
import '../utils/shared_pref.dart';

class UserRepository {
  User user = User(username: "StormX");
  final dio = Dio(
    BaseOptions(
      baseUrl: apiUserUrl,
      contentType: 'application/json',
      receiveDataWhenStatusError: true,
    ),
  );
  Future<User> getUserInfo() async {
    try {
      final accessToken = await getAccessToken();
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get(
        "/me",
      );
      return user = User.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await removeAccessToken();
  }
}
