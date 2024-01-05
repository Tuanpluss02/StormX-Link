import 'dart:ui';

import 'package:flutter/material.dart';

Widget blurContainer({
  EdgeInsetsGeometry? margin,
  double? height,
  double? width,
  required Widget child,
}) {
  return Center(
    child: IntrinsicHeight(
      child: Container(
        margin: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), child: child)),
      ),
    ),
  );
}
