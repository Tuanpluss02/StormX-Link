import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../common/constant.dart';

abstract class IAuthRemoteDataSource {
  Future<Response> login(String username, String password);
  Future<Response> createAccount(String username, String password);
}

@Injectable(as: IAuthRemoteDataSource)
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  @override
  Future<Response> createAccount(String username, String password) async {
    try {
      final response = await _dio.post(
        "$apiAuthUrl/register",
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

  @override
  Future<Response> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "$apiAuthUrl/login",
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
}