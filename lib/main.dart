// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:door/Models/SignUpPage.dart';
import 'package:get/get.dart';
import 'package:door/Models/DoorRunningPages/DoorScanPage.dart';
import 'package:door/Models/DoorRunningPages/RecordPage.dart';
import 'package:door/Models/DoorRunningPages/ShowNamePage.dart';
import 'package:door/Models/DoorRunningPages/DoorRunning_binding.dart';
import 'package:door/Models/Navigator/Navbar.dart';
// ==========main==========
part 'app_routes.dart';
part 'DoorURL.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
            name: _Paths.SignUp, page: () => SignUp(), bindings: [DoorBinding()]),
        GetPage(
            name: _Paths.NavBar, page: () => NavBar(), bindings: [DoorBinding()]),
        GetPage(name: _Paths.DoorScan, page: () => DoorScanPage()),
        GetPage(name: _Paths.Record, page: () => RecordPage()),
        GetPage(name: _Paths.ShowName, page: () => ShowNamePage()),
      ],
      initialRoute: _Paths.SignUp,
    );
  }
}

// ==========main==========
