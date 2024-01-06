import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../common/enums.dart';

void showQrcode(
    BuildContext context, Size size, String shortUrl, ScreenType screenType) {
  showAnimatedDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
              height: screenType == ScreenType.web
                  ? size.height * 0.7
                  : size.height * 0.5,
              width: screenType == ScreenType.web
                  ? size.width * 0.3
                  : size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Scan this QR code to go to the link',
                            style: TextStyle(
                                fontSize:
                                    screenType == ScreenType.web ? 20.0 : 15,
                                fontFamily: 'Atomed'),
                          ),
                          QrImageView(
                            data: shortUrl,
                            version: QrVersions.auto,
                            size: screenType == ScreenType.web ? 400.0 : 300,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))));
    },
    animationType: DialogTransitionType.size,
    curve: Curves.fastOutSlowIn,
    duration: const Duration(seconds: 1),
  );
}
