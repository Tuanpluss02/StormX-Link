import 'dart:ui';

// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_shortener_flutter/const_value.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';
import 'package:url_shortener_flutter/utils/validate.dart';

Future<bool> _submitForm(
  TextEditingController longUrlController,
  TextEditingController shortNameController,
  Rx<String> shortUrl,
) async {
  var returnVal = true;
  final String longUrl = longUrlController.text;
  final String shortName = shortNameController.text;
  late Dio.Response response;
  try {
    /// Making a POST request to the API endpoint with the URL to be shortened.
    response = await Dio.Dio().post('$apiDomain/shorten',
        queryParameters: {
          'long_url': longUrl,
          'short_name': shortName,
        },
        options: Dio.Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    // debugPrint(response.data.toString());
  } on Dio.DioError catch (e) {
    debugPrint(e.toString());
    returnVal = false;
  }
  if (response.statusCode == 202) {
    returnVal = false;
  }
  if (response.statusCode == 200) {
    returnVal = true;
    shortUrl.value = response.data['short_url'];
  }
  return returnVal;
}

Widget shortenForm(
    Size size,
    GlobalKey<FormState> formKey,
    BuildContext context,
    TextEditingController longUrlController,
    TextEditingController shortNameController,
    Rx<String> shortUrl,
    BoolVar isSuccess,
    BoolVar isSubmitting) {
  return Container(
    margin: EdgeInsets.only(
        top: size.height * 0.2,
        left: size.width * 0.2,
        right: size.width * 0.2),
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
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          // color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('URL Shortener Launcher',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'RobotReavers',
                      )),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: longUrlController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black54, width: 2.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black54, // Set the color you want here
                      ),
                      labelText: 'Long URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid URL';
                      }
                      if (!RegexValidate().isValidLongUrl(value)) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: shortNameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black54, width: 2.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1.0),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black45),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black54, // Set the color you want here
                      ),
                      labelText: 'Short Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegexValidate().isValidShortName(value)) {
                        return 'Please enter a valid short name(eg: stormx-app)';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      shortUrl.value = apiDomain + newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  SubmitButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        isSubmitting.val = true;
                        isSuccess.val = await _submitForm(
                            longUrlController, shortNameController, shortUrl);
                      }
                    },
                    isSuccess: isSuccess,
                    isSubmitting: isSubmitting,
                    textSuccess: 'Thanks for using my app!',
                    textFail: 'Failed to shorten URL', navigator: () {  },
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => Row(
                      children: [
                        Text.rich(TextSpan(
                            text: 'Result: ',
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'Atomed'),
                            children: <InlineSpan>[
                              isSuccess.val
                                  ? TextSpan(
                                      text: shortUrl.value,
                                      style: const TextStyle(
                                          // fontFamily: "Despairs",
                                          color: Colors.green),
                                    )
                                  : TextSpan(
                                      text: shortUrl.isNotEmpty
                                          ? "Short name is already taken, please try another one"
                                          : "",
                                      style: const TextStyle(
                                          // fontFamily: "Despairs",
                                          color:
                                              Color.fromARGB(255, 231, 50, 50)),
                                    )
                            ])),
                        const SizedBox(
                          width: 10,
                        ),
                        (shortUrl.value.isNotEmpty && isSuccess.val)
                            ? TextButton.icon(
                                onPressed: () {
                                  if (shortUrl.value.isNotEmpty) {
                                    Clipboard.setData(
                                            ClipboardData(text: shortUrl.value))
                                        .then((value) => showToast(
                                            'Copied to clipboard',
                                            context: context));
                                  }
                                },
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Copy',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : const SizedBox(),
                        (shortUrl.value.isNotEmpty && isSuccess.val)
                            ? TextButton.icon(
                                onPressed: () {
                                  if (shortUrl.value.isNotEmpty) {
                                    showAnimatedDialog(
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext dialogContext) {
                                        return Dialog(
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                                height: size.height * 0.7,
                                                width: size.width * 0.3,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 8, sigmaY: 8),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            const Text(
                                                              'Scan this QR code to go to the link',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.0,
                                                                  fontFamily:
                                                                      'Atomed'),
                                                            ),
                                                            Obx(
                                                              () => QrImage(
                                                                data: shortUrl
                                                                    .value,
                                                                version:
                                                                    QrVersions
                                                                        .auto,
                                                                size: 400.0,
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black54,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    dialogContext);
                                                              },
                                                              child: const Text(
                                                                'Close',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                },
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'QR Code',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
