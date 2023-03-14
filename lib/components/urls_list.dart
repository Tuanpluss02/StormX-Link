import 'package:flutter/material.dart';

class URLList extends StatelessWidget {
  const URLList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Shortener Launcher'),
      ),
      body: const Center(
        child: Text('URL List'),
      ),
    );
  }
}
