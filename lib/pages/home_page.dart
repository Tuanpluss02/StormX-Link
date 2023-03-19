// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_shortener_flutter/components/recently_widget.dart';
import 'package:url_shortener_flutter/components/shorten_form.dart';
import 'package:url_shortener_flutter/const_value.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/models/urls.dart';
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    super.initState();
    getRecentlyUrls();
  }

  @override
  void dispose() {
    _longUrlController.dispose();
    _shortNameController.dispose();
    super.dispose();
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
      dataFetched = mapUrls.map((e) => Urls.fromJson(e)).toList();
      dataFetched = dataFetched.reversed.toList();
      getMoreData();
      // debugPrint("On init : ${recentlyUrls.value.length.toString()}");
    }
  }

  getMoreData() {
    setState(() {
      for (int i = _currentIndexLoaded; i < _currentIndexLoaded + 10; i++) {
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
                        isSubmitting,
                        isSuccess),
                    credit(),
                    recentlyWidget(size, _scrollController, recentlyUrls),
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
