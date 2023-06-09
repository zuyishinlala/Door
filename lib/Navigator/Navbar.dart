// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:door/Navigator/NavBar_controller.dart';
import 'package:door/Pages/NavPage/DoorScanPage.dart';
import 'package:door/Pages/NavPage/ShowNamePage.dart';
import 'package:door/Pages/NavPage/RecordPage.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  late DoorController door = Get.find<DoorController>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final map = await Get.arguments;
    door.SetDoor(map);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavBarController>(builder: (context) {
      return Scaffold(
        body: SafeArea(
            child: IndexedStack(index: controller.Tabindex, children: const [
          DoorScanPage(),
          RecordPage(),
          ShowNamePage()
        ])),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.Tabindex,
            onTap: controller.ChangeTabIndex,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey.shade200,
            items: [
              bottomBarItem(IconlyBold.camera, 'Scanning'),
              bottomBarItem(IconlyBold.document, 'Record'),
              bottomBarItem(IconlyBold.home, 'About')
            ]),
      );
    });
  }

  bottomBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
