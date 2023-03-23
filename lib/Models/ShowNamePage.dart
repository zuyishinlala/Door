import 'package:flutter/material.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
          Container(
              height: 300,
              width: 300,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: QrImage(
                  data: door.Name.value,
                  version: 10,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                ),
              ),
          ),
        ],
      )
    );
  }
}