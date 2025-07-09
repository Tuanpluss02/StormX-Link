import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

@Injectable(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IUserRemoteDataSource _remoteDataSource;
  final IAuthLocalDataSource _localDataSource;

  UserRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<UserEntity> getUserInfo() async {
    final userModel = await _remoteDataSource.getUserInfo();
    return userModel.toEntity();
  }

  @override
  Future<void> logout() {
    return _localDataSource.logout();
  }
}