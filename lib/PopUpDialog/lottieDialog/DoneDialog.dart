// ignore_for_file: file_names

import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lottiecontroller.dart';
Future doneDialog(String dialogtitle) {
  return Get.defaultDialog(
    title: dialogtitle,
    content: const LottieDialog(),
  );
}

class LottieDialog extends GetView<LottieController> {
  const LottieDialog({super.key});

  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.height * 0.2,
      child: Transform.scale(
        scale: 1.3,
        child: Lottie.asset(
          'assets/lottie/done.json',
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

