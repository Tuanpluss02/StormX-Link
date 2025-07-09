import 'package:injectable/injectable.dart';
import '../entities/user_entity.dart';
import '../repositories/i_user_repository.dart';

@injectable
class GetUserInfoUseCase {
  final IUserRepository _userRepository;

  GetUserInfoUseCase(this._userRepository);

  Future<UserEntity> call() {
    return _userRepository.getUserInfo();
  }
}

@injectable
class LogoutUseCase {
  final IUserRepository _userRepository;

  LogoutUseCase(this._userRepository);

  Future<void> call() {
    return _userRepository.logout();
  }
}