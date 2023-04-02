// ignore: library_prefixes
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:url_shortener_flutter/components/recently_widget.dart';
import 'package:url_shortener_flutter/components/shorten_form.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/urls.dart';
import 'package:url_shortener_flutter/services/api.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDone = false;
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
      } else if (_currentIndexLoaded >= dataFetched.length) {
        setState(() {
          isDone = true;
        });
      }
    });
    super.initState();
    fetchData().then((value) {
      getMoreData();
    });
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
                    Obx(
                      () => recentlyUrls.value.isNotEmpty
                          ? recentlyWidget(size, recentlyUrls, isDone)
                          : const CircularProgressIndicator(),
                    )
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
