import 'dart:ui';

// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_shortener_flutter/components/item_widget.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';
import 'package:url_shortener_flutter/utils/validate.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Rx<List<Urls>> recentlyUrls = Rx<List<Urls>>([]);
  final _longUrlController = TextEditingController();
  final _shortNameController = TextEditingController();
  Rx<String> shortUrl = ''.obs;
  final String apiDomain = 'https://stormx.vercel.app';
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    getRecentlyUrls();
  }

  @override
  void dispose() {
    _longUrlController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  Future<void> deleteUrl(
      String id, VoidCallback onSuccess, VoidCallback onError) async {
    late Dio.Response response;
    try {
      response = await Dio.Dio().delete(
        '$apiDomain/admin/delete-url',
        queryParameters: {'id': id},
      );
    } on Dio.DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode == 200) {
      recentlyUrls.value.removeWhere((element) => element.id == id);
      onSuccess.call();
    } else {
      onError.call();
    }
  }

  getRecentlyUrls() async {
    late Dio.Response response;
    try {
      response = await Dio.Dio().get('$apiDomain/admin/get_urls',
          options: Dio.Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));
      // debugPrint(response.data.toString());
    } on Dio.DioError catch (e) {
      debugPrint(e.toString());
    }
    if (response.statusCode == 200) {
      var mapUrls = response.data['urls'] as List;
      recentlyUrls.value = mapUrls.map((e) => Urls.fromJson(e)).toList();
      recentlyUrls.value = recentlyUrls.value.reversed.toList();
    }
  }

  Future<bool> _submitForm() async {
    var returnVal = true;
    final String longUrl = _longUrlController.text;
    final String shortName = _shortNameController.text;
    late Dio.Response response;
    try {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      children: [
        Image.asset("assets/background.jpg",
            width: size.width, height: size.height, fit: BoxFit.cover),
        WebSmoothScroll(
          controller: _scrollController,
          scrollOffset: 60,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                mainView(size, formKey, context),
                credit(),
                recentlyWidget(size),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget recentlyWidget(Size size) {
    return Container(
        margin: EdgeInsets.only(
          left: size.width * 0.2,
          right: size.width * 0.2,
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
                margin: const EdgeInsets.all(20),
                child: Obx(() => recentlyUrls.value.isNotEmpty
                    ? ListView.builder(
                        itemCount: recentlyUrls.value.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = recentlyUrls.value[index];
                          return Column(
                            children: [
                              ItemWidget(
                                title: item.shortUrl!,
                                description: item.longUrl!,
                                onCopy: () {
                                  Clipboard.setData(
                                      ClipboardData(text: item.shortUrl));
                                  showNotifier(context, 'Copied to clipboard');
                                },
                                onQrGen: () {
                                  showAnimatedDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
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
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 8, sigmaY: 8),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Text(
                                                            'Scan this QR code to go to the link',
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontFamily:
                                                                    'Atomed'),
                                                          ),
                                                          QrImage(
                                                            data:
                                                                item.shortUrl!,
                                                            version:
                                                                QrVersions.auto,
                                                            size: 400.0,
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
                                },
                                onEdit: () {
                                  // handle edit button press
                                },
                                onDelete: () {
                                  showAnimatedDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext dialogContext) {
                                      return Dialog(
                                          elevation: 0,
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                              height: size.height * 0.4,
                                              width: size.width * 0.2,
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
                                                      BorderRadius.circular(20),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 8, sigmaY: 8),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          const Text(
                                                            'Are you sure you want to delete this link?',
                                                            style: TextStyle(
                                                                fontSize: 20.0,
                                                                fontFamily:
                                                                    'Atomed'),
                                                          ),
                                                          Row(
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                  deleteUrl(
                                                                      item.id!,
                                                                      () {
                                                                    showNotifier(
                                                                        context,
                                                                        'Successfully deleted');
                                                                  }, () {
                                                                    showNotifier(
                                                                        context,
                                                                        'Error: Something went wrong');
                                                                  });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Delete',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ],
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
                                },
                              ),
                              const Divider()
                            ],
                          );
                        })
                    : const CircularProgressIndicator())),
          ),
        ));
  }

  void showNotifier(BuildContext context, String message) {
    showToast(message,
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        animDuration: const Duration(seconds: 1),
        duration: const Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
  }

  Container credit() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Text(
        'Made with ❤️ by StormX',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Atomed',
        ),
      ),
    );
  }

  Container mainView(
      Size size, GlobalKey<FormState> formKey, BuildContext context) {
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
                      controller: _longUrlController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
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
                      controller: _shortNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
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
                                              text: shortUrl.value))
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
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Container(
                                                  height: size.height * 0.7,
                                                  width: size.width * 0.3,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
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
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 8,
                                                                sigmaY: 8),
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
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
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .black54,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      dialogContext);
                                                                },
                                                                child:
                                                                    const Text(
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
                                        animationType:
                                            DialogTransitionType.size,
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
}
