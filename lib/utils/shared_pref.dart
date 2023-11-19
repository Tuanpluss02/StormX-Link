import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setAccessToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("Access_token", token);
}

Future<String> getAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("Access_token")!;
}
