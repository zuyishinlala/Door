// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future ErrorMessage(String code, String reason) {
  return Get.defaultDialog(
    radius: 5,
    middleText: 'Code Error: $code\nReason: $reason',
    middleTextStyle: const TextStyle(fontSize: 15),
    backgroundColor: Colors.white,
    textConfirm: 'Yes',
    buttonColor: Colors.amber,
    confirmTextColor: Colors.black26,
    onConfirm: () => Get.back()
  );
}
