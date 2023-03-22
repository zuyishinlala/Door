import 'package:flutter/material.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:get/get.dart';

class ShowNamePage extends StatelessWidget {
  late DoorController door = Get.find<DoorController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Show Name Page'),
          leading : IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          )
        ),
        body: Column(children: [
          Text(
            '${door.Name.value}',
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '${door.share.value}',
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          Text(
            '${door.secret.value}',
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
        ],
      )
    );
  }
}