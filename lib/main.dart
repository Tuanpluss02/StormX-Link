import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'URL Shortener Launcher',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: const {},
      // home: const HomePage(),
    );
  }
}
