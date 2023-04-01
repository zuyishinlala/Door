// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:door/Record.dart';
import 'package:http/http.dart' as http;
import 'package:door/main.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class ShowNamePage extends StatelessWidget {
  late DoorController door = Get.find<DoorController>();

  ShowNamePage({super.key});
  void ErrorMessage(String code, String reason) {
    Get.defaultDialog(
      radius: 5,
      middleText: 'Code Error: ${code}\nReason: ${reason}',
      middleTextStyle: const TextStyle(fontSize: 15),
      backgroundColor: Colors.white10,
    );
    Timer(const Duration(seconds: 1), () {
      Get.back();
    });
  }

  Future<void> DeleteDoorRequest() async {
    try {
      var response = await http.post(Uri.https(door.serverAdd, DoorURL.create),
          body: door.DoorRequest());
      if (response.statusCode == 200) {
        Timer(const Duration(seconds: 2), () {
          Get.offNamed(Routes.SignUp);
        });
      } else {
        var Data = jsonDecode(response.body);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      GetBuilder<DoorController>(
        id: 'AppBar',
        builder: (door) {
          return AppBar(
            backgroundColor:
                door.locked.value ? Colors.red[400] : Colors.green[400],
            title: Text('Name Page'),
          );
        },
      ),
      Text(
        'Door Name:${door.Name.value}',
        style: TextStyle(
            color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w700),
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
          Record newRecord = Record(Name, date, time);
          door.insertRecord(newRecord);
        },
      ),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          fixedSize: const Size(250, 80),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          textStyle: const TextStyle(fontSize: 20),
          side: const BorderSide(width: 5, color: Colors.redAccent),
        ),
        icon: const Icon(Icons.delete),
        label: const Text('Delete Door',
            style: TextStyle(color: Colors.redAccent)),
        onPressed: () {
          Get.defaultDialog(
              title: "Delete Door Comfirmation",
              radius: 5,
              middleText: 'Are you certain?',
              middleTextStyle: const TextStyle(fontSize: 20),
              backgroundColor: Colors.white,
              buttonColor: Colors.amber,
              textCancel: 'Cancel',
              cancelTextColor: Colors.black,
              onCancel: () => Get.back(),
              textConfirm: 'Yes',
              confirmTextColor: Colors.black,
              onConfirm: () => DeleteDoorRequest());
        },
      ),
    ]));
  }
}
