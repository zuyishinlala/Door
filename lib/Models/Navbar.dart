import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:door/Models/NavBar_controller.dart';
import 'package:door/Models/DoorRunning.dart';
import 'package:door/Models/ShowNamePage.dart';
import 'package:door/Models/RecordPage.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:door/main.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final controller = Get.put(NavBarController());
  late DoorController door = Get.find<DoorController>();

  @override
  void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final map = await Get.arguments;
    print('in NavBar');
    print(map);
    setState(() {
      door.SetDoor(map);
    });
  }

  @override
  Widget build(BuildContext Context) {
    return GetBuilder<NavBarController>(builder: (Context) {
      return Scaffold(
        body: SafeArea(
            child: IndexedStack(
              index: controller.Tabindex,
              children: [ 
                DoorRunning(),
                ShowNamePage(), 
                RecordPage()
              ]
            )
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.Tabindex,
            onTap: controller.ChangeTabIndex,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.grey.shade200,
            items: [
              bottomBarItem(IconlyBold.home, 'Home'),
              bottomBarItem(IconlyBold.document, 'Record'),
              bottomBarItem(IconlyBold.discovery, 'DoorName')
            ]),
      );
    });
  }

  bottomBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }
}
