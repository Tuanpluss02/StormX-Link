import 'package:flutter/material.dart';
import 'package:url_shortener_flutter/components/main_card.dart';

void main() {
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
        primarySwatch: Colors.blue,
      ),
      home: const MainCard(),
    );
  }
}
