import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LottieController extends GetxController
    with
        // ignore: deprecated_member_use
        SingleGetTickerProviderMixin {
  late AnimationController animationController;
  @override
  void onInit() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    animationController.forward();

    animationController.repeat(reverse: true);
    super.onInit();
  }
}
