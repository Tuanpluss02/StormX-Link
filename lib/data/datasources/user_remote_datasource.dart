import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../common/constant.dart';
import '../../utils/shared_pref.dart';
import '../models/user_model.dart';

abstract class IUserRemoteDataSource {
  Future<UserModel> getUserInfo();
}

@Injectable(as: IUserRemoteDataSource)
class UserRemoteDataSource implements IUserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final accessToken = await getAccessToken();
      final response = await _dio.get(
        "$apiUserUrl/me",
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}