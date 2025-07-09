import 'package:injectable/injectable.dart';
import '../../utils/shared_pref.dart';

abstract class IAuthLocalDataSource {
  Future<bool> checkUserLoggedIn();
  Future<void> logout();
}

@Injectable(as: IAuthLocalDataSource)
class AuthLocalDataSource implements IAuthLocalDataSource {
  @override
  Future<bool> checkUserLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await removeAccessToken();
  }
}