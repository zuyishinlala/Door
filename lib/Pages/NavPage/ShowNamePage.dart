// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:door/main.dart';

import '../../Https/HttpResponseFormat.dart';
import '../../PopUpDialog/ErrorDialog.dart';
import '../../Https/Https.dart';

class ShowNamePage extends StatefulWidget {
  const ShowNamePage({super.key});

  @override
  State<ShowNamePage> createState() => _ShowNamePageState();
}

class _ShowNamePageState extends State<ShowNamePage> {
  late DoorController door = Get.find<DoorController>();
  late MediaQueryData queryData = queryData = MediaQuery.of(context);
  void update() async {
    ResponseFormat response =
        await HttpUpdate(door.serverAdd, door.DoorRequest());
    if (response.code == 200) {
      door.UpdateDoor(response.data);
    } else if (response.code == -1) {
      ErrorMessage('-1', 'Update with no http connection.');
    } else {
      ErrorMessage(response.data['code'], response.data['reason']);
    }
  }

  void delete() async {
    ResponseFormat response =
        await HttpDelete(door.serverAdd, door.DoorRequest());
    if (response.code == 200) {
      Get.delete<DoorController>(force: true);
      Get.offNamed(Routes.SignUp);
    } else if (response.code == -1) {
      Get.delete<DoorController>(force: true);
      Get.offNamed(Routes.SignUp);
    } else {
      ErrorMessage(response.data['code'], response.data['reason']);
    }
  }

  Widget IconOutlineButton(String mode) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize:
            Size(queryData.size.width * 0.6, queryData.size.width * 0.12),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        textStyle: const TextStyle(fontSize: 25),
        side: BorderSide(
            width: 5,
            color: mode == 'Delete' ? Colors.redAccent : Colors.greenAccent),
      ),
      icon: Icon(mode == 'Delete' ? Icons.delete : Icons.refresh_rounded),
      label: Text('${mode} Door',
          style: TextStyle(
              color: mode == 'Delete' ? Colors.red[400] : Colors.green[400])),
      onPressed: () {
        Get.defaultDialog(
            title: "${mode} Door Comfirmation",
            radius: 5,
            middleText: 'Are you certain?',
            middleTextStyle: const TextStyle(fontSize: 25),
            backgroundColor: Colors.white,
            buttonColor: Colors.amber,
            textCancel: 'Cancel',
            cancelTextColor: Colors.black,
            onCancel: () => Get.back(),
            textConfirm: 'Yes',
            confirmTextColor: Colors.black,
            onConfirm: () => mode == 'Delete' ? delete() : update());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GetBuilder<DoorController>(
        id: 'AppBar',
        builder: (door) {
          return AppBar(
            backgroundColor: door.locked ? Colors.red[400] : Colors.green[400],
            title: const Text('Name Page'),
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: Text(
          'Door Name: ${door.Name}',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 25,
              fontWeight: FontWeight.w700),
        ),
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
      TextButton(
        child: Text(
          'unlock',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 27,
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          door.unlock();
        },
      ),
      TextButton(
        child: Text(
          'add Record',
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 27,
              fontWeight: FontWeight.w700),
        ),
        onPressed: () {
          String Name = 'Daniel';
          door.insertTempRecord(Name);
        },
      ),
      const Spacer(),
      IconOutlineButton('Delete'),
      const SizedBox(
        height: 10,
      ),
      IconOutlineButton('Update'),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}