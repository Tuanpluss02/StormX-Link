import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<String?> readStorage(String key) async {
  String? value = await storage.read(key: key);
  return value;
}

Future<void> deleteStorage(String key) async {
  await storage.delete(key: key);
}

Future<void> writeStorage(String key, String value) async {
  await storage.write(key: key, value: value);
}
