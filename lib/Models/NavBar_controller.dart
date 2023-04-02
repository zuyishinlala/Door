// ignore_for_file: file_names, non_constant_identifier_names

import 'package:get/get.dart';

class NavBarController extends GetxController {
  var Tabindex = 0;
  void ChangeTabIndex(int idx) {
    Tabindex = idx;
    update();
  }
}
