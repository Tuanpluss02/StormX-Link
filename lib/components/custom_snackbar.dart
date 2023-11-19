import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

ScaffoldMessengerState showMaterialBanner({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
}) {
  final materialBanner = MaterialBanner(
    // elevation: 0,
    backgroundColor: Colors.transparent,
    // forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      inMaterialBanner: true,
    ),
    actions: const [SizedBox.shrink()],
  );

  return ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(materialBanner);
}

ScaffoldMessengerState showSnackBar({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
