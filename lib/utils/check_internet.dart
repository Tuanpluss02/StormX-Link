import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> hasInternetConnection() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}
