import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

Widget riveAnimation({
  required Function(Artboard) onInit,
  required String riveNetworkUrl,
}) {
  return Center(
    child: RiveAnimation.network(riveNetworkUrl,
        fit: BoxFit.contain, onInit: onInit),
  );
}
