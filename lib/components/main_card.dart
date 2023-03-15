import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';

class MainCard extends StatefulWidget {
  const MainCard({super.key});

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard>
    with SingleTickerProviderStateMixin {
  final _longUrlController = TextEditingController();
  final _shortNameController = TextEditingController();
  Rx<String> shortUrl = ''.obs;
  final String domain = 'https://stormx.vercel.app/';
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  @override
  void dispose() {
    _longUrlController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  Future<bool> _submitForm() async {
    final String longUrl = _longUrlController.text;
    final String shortName = _shortNameController.text;
    const String url = 'https://stormx.vercel.app/shorten';
    try {
      final response = await Dio().post(
        url,
        queryParameters: {
          'long_url': longUrl,
          'short_name': shortName,
        },
      );
      shortUrl.value = response.data['short_url'];
      isSuccess.val = true;
      return true;
    } catch (e) {
      Logger.root.severe(e.toString());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.5;
    final cardHeight = size.height * 0.52;
    final formKey = GlobalKey<FormState>();
    return Card(
        child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8D5F2),
            Color(0xFFAEE1F9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('URL Shortener Launcher',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _longUrlController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
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
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _shortNameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black45),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Short Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid short name(eg: stormx-app)';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            shortUrl.value = domain + newValue!;
                          },
                        ),
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
                                  // style: const TextStyle(),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: shortUrl.value,
                                      style:
                                          const TextStyle(color: Colors.green),
                                    )
                                  ])),
                              const SizedBox(
                                width: 10,
                              ),
                              shortUrl.value.isNotEmpty
                                  ? TextButton.icon(
                                      onPressed: () {
                                        if (shortUrl.value.isNotEmpty) {
                                          Clipboard.setData(ClipboardData(
                                              text: shortUrl.value));
                                        }
                                      },
                                      icon: const Icon(Icons.copy),
                                      label: const Text('Copy'),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
