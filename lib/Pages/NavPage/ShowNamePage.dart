// ignore_for_file: file_names

import 'dart:async';

import 'package:door/PopUpDialog/lottieDialog/DoneDialog.dart';
import 'package:flutter/material.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:door/main.dart';

import '../../Https/HttpResponseFormat.dart';
import '../../PopUpDialog/ErrorDialog.dart';
import '../../Https/Https.dart';
import '../../PopUpDialog/NohttpDialog.dart';

class ShowNamePage extends StatefulWidget {
  const ShowNamePage({super.key});

  @override
  State<ShowNamePage> createState() => _ShowNamePageState();
}

class _ShowNamePageState extends State<ShowNamePage> {
  late DoorController door = Get.find<DoorController>();
  late MediaQueryData queryData = queryData = MediaQuery.of(context);

  Future<void> update() async {
    ResponseFormat response =
        await HttpUpdate(door.serverAdd, door.DoorRequest());
    if (response.code == 200) {
      doneDialog('Door updated successfully!');
      door.UpdateDoor(response.data);
      door.insertUpdates('Door updated');
      closeDialogTimer(2);
    } else {
      ErrorDialog(response.data['code'], response.data['detail']);
      closeDialogTimer(1);
    }
  }

  Future<void> delete() async {
    ResponseFormat response =
        await HttpDelete(door.serverAdd, door.DoorRequest());
    if (response.code == 200 || response.code == 204) {
      doneDialog('Door deleted successfully, bye!');
      Timer(const Duration(seconds: 2), (() {
        Get.delete<DoorController>(force: true);
        Get.offNamed(Routes.SignUp);
      }));
    } else {
      if (response.code == -1) {
        Get.delete<DoorController>(force: true);
        Timer(const Duration(seconds: 2), () => Get.offNamed(Routes.SignUp));
        NoHttpDialog(response.data['detail']);
      } else {
        ErrorDialog(response.data['code'], response.data['detail']);
        closeDialogTimer(1);
      }
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
  closeDialogTimer(int num) {
    Timer(const Duration(seconds: 3), (() {
      for (int i = 0; i < num; ++i) {
        if (_isThereCurrentDialogShowing(context)) {
          Get.back();
        }
      }
    }));
  }

  // ignore: non_constant_identifier_names
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
      label: Text('$mode Door',
          style: TextStyle(
              color: mode == 'Delete' ? Colors.red[400] : Colors.green[400])),
      onPressed: () {
        Get.defaultDialog(
            title: "$mode Door Comfirmation",
            radius: 5,
            middleText: 'Are you certain?',
            middleTextStyle: const TextStyle(fontSize: 25),
            backgroundColor: Colors.white,
            buttonColor: Colors.amber,
            textCancel: 'Cancel',
            cancelTextColor: Colors.black,
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
            automaticallyImplyLeading: false,
            backgroundColor: door.locked ? Colors.red[400] : Colors.green[400],
            title: const Text('Name Page'),
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Obx(() => Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Door Name: ${door.Name}',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
          )),
      Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        alignment: Alignment.centerLeft,
        child: const Text(
          'About this door:',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color.fromARGB(255, 86, 143, 171),
              fontSize: 30,
              fontWeight: FontWeight.w700),
        ),
      ),
      Expanded(
        flex: 6,
        child: Obx(
          () => ListView.builder(
              itemCount: door.updates.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    door.updates[index].showdate
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(door.updates[index].date,
                                style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                          )
                        : const SizedBox.shrink(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(door.updates[index].mode),
                        subtitle: Text(door.updates[index].time),
                      ),
                    )
                  ],
                );
              }),
        ),
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
