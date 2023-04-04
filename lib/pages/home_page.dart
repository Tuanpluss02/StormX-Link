// ignore: library_prefixes
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:url_shortener_flutter/components/recently_widget.dart';
import 'package:url_shortener_flutter/components/shorten_form.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:url_shortener_flutter/services/storage.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    super.initState();
    checkLogin().then((value) {
      if (!value) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    fetchData().then((value) {
      getMoreData();
    });
  }

  Future<bool> checkLogin() async {
    var checkLogin = await readStorage('token');
    return checkLogin != null;
  }

  Future<void> fetchData() async {
    dataFetched = await Auth().getRecentlyUrls();
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
                    Container(
                        // margin: EdgeInsets.only(bottom: size.height * 0.8),
                        width: size.width,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          // borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                            // borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    const Text('Hi, User',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'RobotReavers',
                                          color: Colors.white,
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          signOut(() {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          });
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
                                )))),
                    shortenForm(
                        size,
                        formKey,
                        context,
                        _longUrlController,
                        _shortNameController,
                        shortUrl,
                        recentlyUrls,
                        isSubmitting,
                        isSuccess),
                    credit(),
                    Obx(() => recentlyWidget(size, recentlyUrls))
                  ],
                ),
              ),
            )
          ],
        ));
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
