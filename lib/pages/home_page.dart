import 'dart:ui';

// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';
import 'package:url_shortener_flutter/utils/validate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AssetImage bg;
  final _longUrlController = TextEditingController();
  final _shortNameController = TextEditingController();
  Rx<String> shortUrl = ''.obs;
  final String domain = 'https://stormx.vercel.app/';
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());

  @override
  void initState() {
    bg = const AssetImage('background.jpg');
    super.initState();
  }

  @override
  void dispose() {
    _longUrlController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  Future<bool> _submitForm() async {
    var returnVal = true;
    final String longUrl = _longUrlController.text;
    final String shortName = _shortNameController.text;
    const String url = 'https://stormx.vercel.app/shorten';
    late Dio.Response response;
    try {
      response = await Dio.Dio().post(url,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      children: [
        Image.asset("images/background.jpg",
            width: size.width, height: size.height, fit: BoxFit.cover),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.2,
            vertical: size.height * 0.2,
          ),
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
                          controller: _longUrlController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 2.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelStyle: const TextStyle(
                              color:
                                  Colors.black54, // Set the color you want here
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
                          controller: _shortNameController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 2.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelStyle: const TextStyle(
                              color:
                                  Colors.black54, // Set the color you want here
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
                            shortUrl.value = domain + newValue!;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Image.asset(
                        //   "voz1.jpg",
                        //   fit: BoxFit.scaleDown,
                        // ),
                        const SizedBox(height: 20),
                        SubmitButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              isSubmitting.val = true;
                              isSuccess.val = await _submitForm();
                            }
                          },
                          isSuccess: isSuccess,
                          isSubmitting: isSubmitting,
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
                                                color: Color.fromARGB(
                                                    255, 231, 50, 50)),
                                          )
                                  ])),
                              const SizedBox(
                                width: 10,
                              ),
                              (shortUrl.value.isNotEmpty && isSuccess.val)
                                  ? TextButton.icon(
                                      onPressed: () {
                                        if (shortUrl.value.isNotEmpty) {
                                          Clipboard.setData(ClipboardData(
                                              text: shortUrl.value));
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        const Center(
                          child: Text('Made by Tuan Do',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: 'Despairs',
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
