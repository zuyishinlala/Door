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

import '../Https/HttpResponseFormat.dart';
import '../Https/Https.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  late DoorController door = Get.find<DoorController>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getData();
    _timer = Timer.periodic(
        const Duration(seconds: 60), (Timer t) => getBlackList());
  }

  Future<void> getData() async {
    final map = await Get.arguments;
    door.SetDoor(map);
  }

  Future<void> getBlackList() async {
    ResponseFormat response =
        await HttpGetList(door.serverAdd, door.DoorRequest());
    if (response.code == 200) {
      var rest = response.data[""] as List;       // todo: revise the name of the list
      List<String> newblacklist = rest.map(((item) => item as String)).toList();
      if (newblacklist.isNotEmpty) {
        door.blacklist.addAll(newblacklist);
        door.insertUpdates('${newblacklist.length} users were added into blacklist');
      }
      //ErrorDialog(response.data['code'], response.data['detail']);
    } 
  }

  @override
  void dispose() {
    _timer.cancel();
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
