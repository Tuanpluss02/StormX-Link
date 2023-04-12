import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:url_shortener_flutter/models/user.dart';
import 'package:url_shortener_flutter/pages/home_page.dart';
import 'package:url_shortener_flutter/pages/login_page.dart';
import 'package:url_shortener_flutter/pages/signup_page.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/services/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale(
          'en', 'US'), //You have to set this parameters to your locale
      textStyle: const TextStyle(
          fontSize: 16.0, color: Colors.white), //Default text style of toast
      backgroundColor: const Color(0x99000000), //Background color of toast
      borderRadius: BorderRadius.circular(10.0), //Border radius of toast
      textPadding: const EdgeInsets.symmetric(
          horizontal: 17.0, vertical: 10.0), //The padding of toast text
      toastPositions: StyledToastPosition.bottom, //The position of toast
      toastAnimation: StyledToastAnimation.fade, //The animation type of toast
      animDuration: const Duration(
          seconds: 1), //The duration of animation(including reverse) of toast
      dismissOtherOnShow:
          true, //When we show a toast and other toast is showing, dismiss any other showing toast before.
      fullWidth:
          false, //Whether the toast is full screen (subtract the horizontal margin)
      isHideKeyboard: false, //Is hide keyboard when toast show
      isIgnoring: true, //Is the input ignored for the toast
      animationBuilder: (
        BuildContext context,
        AnimationController controller,
        Duration duration,
        Widget child,
      ) {
        // Builder method for custom animation
        return SlideTransition(
          position: getAnimation<Offset>(
              const Offset(0.0, 3.0), const Offset(0, 0), controller,
              curve: Curves.bounceInOut),
          child: child,
        );
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'URL Shortener Launcher',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        initialRoute: '/login',
        routes: {
          // '/home': (context) => HomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
        },
        // home: const HomePage(),
      ),
    );
  }
}
