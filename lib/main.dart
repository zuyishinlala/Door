// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


import 'package:door/Pages/SignUpPage.dart';
import 'package:get/get.dart';
import 'package:door/DoorController/DoorRunning_binding.dart';
import 'package:door/Navigator/Navbar.dart';

// ==========main==========
part 'app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
            name: Routes.SignUp, page: () => SignUp()),
        GetPage(
            name: Routes.NavBar, page: () => NavBar(), bindings: [DoorBinding()]),
      ],
      initialRoute: Routes.SignUp,
    );
  }
}

// ==========main==========
