import 'package:get/get.dart';
import 'package:url_shortener_flutter/models/urls.dart';

class ListUrlsController extends GetxController {
  final _listUrls = <Urls>[].obs;
  List<Urls> get listUrls => _listUrls;
  set listUrls(List<Urls> value) {
    _listUrls.value = value;
    update();
  }

  void addUrls(Urls urls) {
    _listUrls.add(urls);
    update();
  }

  void removeUrls(String shortname) {
    _listUrls.removeWhere((element) => element.shortname == shortname);
    update();
  }
}
