import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../common/constant.dart';

Widget bearAnimation({
  required Function(Artboard) onInit,
}) {
  return Center(
    child: SizedBox(
      height: 200,
      width: 300,
      child: RiveAnimation.network(riveLoginAnimation,
          fit: BoxFit.contain, onInit: onInit),
    ),
  );
}
