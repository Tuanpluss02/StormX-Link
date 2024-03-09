import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setAccessToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("access_token", token);
}

Future<String> getAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("access_token")) {
    return "";
  }
  return prefs.getString("access_token") ?? "";
}

Future<bool> removeAccessToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove("access_token");
}
