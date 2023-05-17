// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future NoHttpDialog(String reason) {
  return Get.defaultDialog(
    radius: 5,
    middleText:
        '(Socket Exception)\nNo http, but still move to next Page...\n',
    middleTextStyle: const TextStyle(fontSize: 18),
    backgroundColor: Colors.white,
  );
}

