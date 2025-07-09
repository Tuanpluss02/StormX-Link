import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final IAuthLocalDataSource _localDataSource;

  AuthRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Response> createAccount(String username, String password) {
    return _remoteDataSource.createAccount(username, password);
  }

  @override
  Future<Response> login(String username, String password) {
    return _remoteDataSource.login(username, password);
  }

  @override
  Future<bool> checkUserLoggedIn() {
    return _localDataSource.checkUserLoggedIn();
  }
}