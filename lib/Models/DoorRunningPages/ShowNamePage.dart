// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:door/Models/DoorRunningPages/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:door/Models/DoorRunningPages/RecordBlocks/Record.dart';
import 'package:http/http.dart' as http;
import 'package:door/main.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ShowNamePage extends StatefulWidget {
  const ShowNamePage({super.key});

  @override
  State<ShowNamePage> createState() => _ShowNamePageState();
}

class _ShowNamePageState extends State<ShowNamePage> {
  late DoorController door = Get.find<DoorController>();
  late MediaQueryData queryData = queryData = MediaQuery.of(context);

  void ErrorMessage(String code, String reason) {
    Get.defaultDialog(
        radius: 5,
        middleText: 'Code Error: ${code}\nReason: ${reason}',
        middleTextStyle: const TextStyle(fontSize: 15),
        backgroundColor: Colors.white10,
        textConfirm: 'Yes',
        buttonColor: Colors.amber,
        confirmTextColor: Colors.black26,
        onConfirm: () => Get.back());
  }

  Future<void> DoorRequest(String mode) async {
    try {
      var response = await http.post(
          Uri.https(door.serverAdd,
              mode == 'Delete' ? DoorURL.delete : DoorURL.update),
          body: door.DoorRequest());
      var Data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        print('${mode} Door,with http');
        if (mode == 'Delete') {
          Timer(const Duration(seconds: 2), () {
            Get.offNamed(Routes.SignUp);
          });
        } else {
          door.UpdateDoor(Data);
        }
      } else {
        ErrorMessage(Data["code"], Data["reason"]);
      }
    } catch (e) {
      if (e is SocketException) {
        print("Socket exception: ${e.toString()}");
      } else if (e is TimeoutException) {
        print("Timeout exception: ${e.toString()}");
      } else {
        print("Unhandled exception: ${e.toString()}");
      }
      print('${mode} Door,without http');
      if (mode == 'Delete') {
        Get.delete<DoorController>(force: true);
        Get.offNamed(Routes.SignUp);
      }
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
            onConfirm: () => DoorRequest(mode));
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
      const SizedBox(height: 10,),
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
      door.unlocked();
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
      String date = DateFormat("MMMM-dd yyyy").format(DateTime.now());
      String time = DateFormat("HH:mm:ss").format(DateTime.now());
      door.insertRecord(Record(Name, date, time));
    },
      ),
      const Spacer(),
      IconOutlineButton('Delete'),
      const SizedBox(height: 10,),
      IconOutlineButton('Update'),
      const SizedBox(height: 20,),
    ]);
  }
}
