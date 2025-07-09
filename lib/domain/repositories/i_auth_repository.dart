import 'package:dio/dio.dart';

abstract class IAuthRepository {
  Future<Response> login(String username, String password);
  Future<Response> createAccount(String username, String password);
  Future<bool> checkUserLoggedIn();
}