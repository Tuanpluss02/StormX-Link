import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:url_shortener_flutter/components/recently_widget.dart';
import 'package:url_shortener_flutter/components/shorten_form.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/models/user.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user = User();
  FocusNode formFocus = FocusNode();
  int _currentIndexLoaded = 0;
  late List<Urls> dataFetched = [];
  late Rx<List<Urls>> recentlyUrls = Rx<List<Urls>>([]);
  final _longUrlController = TextEditingController();
  final _shortNameController = TextEditingController();
  Rx<String> shortUrl = ''.obs;
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (dataFetched.isNotEmpty &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _currentIndexLoaded < dataFetched.length) {
        getMoreData();
      }
    });
    dataFetched = widget.user.urls!;
    getMoreData();
    super.initState();
  }

  @override
  void dispose() {
    _longUrlController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  getMoreData() {
    if (dataFetched.isEmpty) return;
    setState(() {
      for (int i = _currentIndexLoaded;
          i < _currentIndexLoaded + 10 && i < dataFetched.length;
          i++) {
        if (_currentIndexLoaded > dataFetched.length) {
          return;
        }
        recentlyUrls.value.add(dataFetched[i]);
      }
      _currentIndexLoaded += 10;
    });
  }

  Future<void> signOut(VoidCallback navi) async {
    await Auth().signOut();
    navi.call();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    appBar(size, context),
                    shortenForm(
                        size,
                        formKey,
                        context,
                        _longUrlController,
                        _shortNameController,
                        formFocus,
                        shortUrl,
                        recentlyUrls,
                        isSubmitting,
                        isSuccess),
                    credit(),
                    RecentlyWidget(
                      size: size,
                      recentlyUrls: recentlyUrls,
                      longUrlController: _longUrlController,
                      shortNameController: _shortNameController,
                      formFocus: formFocus,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Container appBar(Size size, BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        width: size.width,
        height: size.height * 0.1,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text('Hi, ${widget.user.username}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'RobotReavers',
                          color: Colors.white,
                        )),
                    TextButton(
                        onPressed: () {
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
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.5),
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
                                              margin: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Text(
                                                    'Are you sure you want to sign out?',
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontFamily: 'Atomed'),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  136,
                                                                  255,
                                                                  24,
                                                                  24),
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
                                                          signOut(() {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/login');
                                                          });
                                                        },
                                                        child: const Text(
                                                          'Sign Out',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  135, 0, 0, 0),
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
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Atomed',
                            color: Colors.redAccent,
                          ),
                        ))
                  ],
                ))));
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
}
