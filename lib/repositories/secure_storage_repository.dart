import '../utils/secure_storage_method.dart';

class SecureStorage {
  Future<String?> getAccessToken() async {
    String? accessToken = await readStorage('token');
    return accessToken;
  }
  Future<void> setAccessToken(String token) async {
    await writeStorage('token', token);
  }

  Future<void> deleteAccessToken() async {
    await deleteStorage('token');
  }
}