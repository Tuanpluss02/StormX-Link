import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MyRiveAnimation extends StatefulWidget {
  const MyRiveAnimation({super.key});
  @override
  State<MyRiveAnimation> createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  late RiveAnimationController _controller;
  var base64String = '';
  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    final data = await rootBundle.load('rive/login_bear.riv');
    final bytes = data.buffer.asUint8List();
    base64String = base64Encode(bytes);

    setState(() {
      _controller = SimpleAnimation('idle');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rive Animation'),
      ),
      body: Center(
          child: RiveAnimation.network(
        'data:application/octet-stream;base64,$base64String',
        controllers: [_controller],
      )),
    );
  }
}
