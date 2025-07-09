import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../repositories/i_auth_repository.dart';

@injectable
class LoginUseCase {
  final IAuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Response> call(String username, String password) {
    return _authRepository.login(username, password);
  }
}

@injectable
class CreateAccountUseCase {
  final IAuthRepository _authRepository;

  CreateAccountUseCase(this._authRepository);

  Future<Response> call(String username, String password) {
    return _authRepository.createAccount(username, password);
  }
}

@injectable
class CheckUserLoggedInUseCase {
  final IAuthRepository _authRepository;

  CheckUserLoggedInUseCase(this._authRepository);

  Future<bool> call() {
    return _authRepository.checkUserLoggedIn();
  }
}