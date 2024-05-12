import 'package:flutter/material.dart';
import 'package:link/views/error_page.dart';
import 'package:link/views/signup_page.dart';

import '../views/home_page.dart';
import '../views/login_page.dart';
import '../views/root_page.dart';
import 'route_name.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;
    switch (settings.name) {
      case RouteName.rootPage:
        return _buildRoute(settings, const RootPage());
      case RouteName.homePage:
        return _buildRoute(settings, const HomePage());
      case RouteName.loginPage:
        return _buildRoute(settings, const LoginPage());
      case RouteName.signupPage:
        return _buildRoute(settings, const SignUpPage());
      case RouteName.errorPage:
        return _buildRoute(settings, const ErrorPage());
      default:
        return _errorRoute(settings);
    }
  }
}

Route<dynamic> _buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}

Route _errorRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (_) => const ErrorPage(),
  );
}
