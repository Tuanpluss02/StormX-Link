import 'package:get/get.dart';

class BoolVar extends GetxController {
  final _val = false.obs;
  bool get val => _val.value;
  set val(bool val) => _val.value = val;
}
