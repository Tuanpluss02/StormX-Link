import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

ScaffoldMessengerState showMaterialBanner({
  required BuildContext context,
  required String title,
  required String message,
  required ContentType contentType,
}) {
  final materialBanner = MaterialBanner(
    elevation: 0,
    backgroundColor: Colors.transparent,
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
    duration: const Duration(seconds: 2),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: Align(
      alignment: Alignment.topRight,
      child: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    ),
  );
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// void showTopSnackBar(
//   String message, {
//   bool isSuccess = true,
//   Color? color,
//   Duration? duration,
// }) {
//   final backgroundColor =
//       color ?? (isSuccess ? Colors.green[600] : Colors.red[600]);

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       duration: duration ?? const Duration(milliseconds: 500),
//       backgroundColor: Colors.transparent,
//       content: Align(
//         alignment: Alignment.topCenter,
//         child: Container(
//           height: 100,
//           margin: const EdgeInsets.all(20),
//           padding: const EdgeInsets.all(20),
//           width: double.maxFinite,
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: const BorderRadius.all(
//               Radius.circular(15),
//             ),
//           ),
//           child: Text(
//             message,
//             style: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
