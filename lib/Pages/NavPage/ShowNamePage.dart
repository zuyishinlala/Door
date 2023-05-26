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
  late Timer timer;
  ValueNotifier<String> connecthint = ValueNotifier('Connected');
  late String responseCode = 'None';
  late String errordetail = 'No Detail';
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) => update());
  }

  Future<void> update() async {
    ResponseFormat response =
        await HttpUpdate(door.serverAdd, door.DoorRequest());
    if (response.code == 200) {
      connecthint.value = 'Connected';
      door.UpdateDoor(response.data['share'], response.data['secret']);
      var rest = response.data["is_blacklisted"] as List;
      List<String> newblacklist = rest.map(((item) => item as String)).toList();
      if (newblacklist.isNotEmpty) {
        door.blacklist.addAll(newblacklist);
        door.insertUpdates(
            '${newblacklist.length} users were added into blacklist');
      }
    } else {
      connecthint.value = 'Not connected';
      errordetail = response.data['detail'];
    }
    responseCode = response.code.toString();
  }

  Future<void> delete() async {
    ResponseFormat response =
        await HttpDelete(door.serverAdd, door.DoorRequest());
    if (response.code == 200 || response.code == 204) {
      doneDialog('Door deleted successfully, bye!');
      Timer(const Duration(seconds: 3), (() {
        timer.cancel();
        Get.delete<DoorController>(force: true);
        Get.offNamed(Routes.SignUp);
      }));
    } else {
      if (response.code == -1) {
        timer.cancel();
        Get.delete<DoorController>(force: true);
        Timer(const Duration(seconds: 3), () => Get.offNamed(Routes.SignUp));
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
    Timer(const Duration(seconds: 2), (() {
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
            onConfirm: () {
              Get.back();
              mode == 'Delete'
                  ? {delete()}
                  : { 
                      update(),
                      if(responseCode == '200'){
                        doneDialog('Door updated successfully!'),
                        closeDialogTimer(1),
                      }else{
                        ErrorDialog(responseCode ,errordetail)
                      }
                    };
            });
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
              backgroundColor:
                  door.locked ? Colors.red[400] : Colors.green[400],
              title: const Text('About this door'),
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          ValueListenableBuilder<String>(
              valueListenable: connecthint,
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                      color: connecthint.value == 'Connected'
                          ? Colors.cyanAccent
                          : Colors.grey,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      if (connecthint.value == 'Connected') {
                        // ignore: avoid_returning_null_for_void
                        return null;
                      } else {
                        ErrorDialog(responseCode, errordetail);
                      }
                    },
                    child: Text(connecthint.value,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)
                        ),
                  ),
                );
              }),
        ],
      ),
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
              fontSize: 25,
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
