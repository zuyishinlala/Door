// ignore_for_file: non_constant_identifier_names, file_names

import 'package:door/Https/Https.dart';
import 'package:door/Https/HttpResponseFormat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:door/main.dart';
import 'package:flutter/services.dart';

import '../DoorController/DoorRunning_controller.dart';
import 'package:door/PopUpDialog/lottieDialog/DoneDialog.dart';
import '../PopUpDialog/ErrorDialog.dart';
import '../PopUpDialog/NohttpDialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController NameController = TextEditingController();
  TextEditingController IpController = TextEditingController();
  TextEditingController PortController = TextEditingController();
  String serverAdd = '10.201.35.40:8000'; 
  //#################################################################
  late DoorController door = Get.find<DoorController>();
  Uint8List secret = Uint8List.fromList(List.filled(50, 0));
  Uint8List DoorShare = Uint8List.fromList(List.filled(200, 0));
  Uint8List UserShare = Uint8List.fromList(List.filled(200, 0));
  String secret64 =
      "SUNh2uxvZKqvmBZx7ABjIHWJOay3W2NofvZ7u5nd0HjjrSpcdEhGyPl51MTR+56jtMg=";
  String doorShare64 =
      "p1Xryto115a7yX2mnJlmlZxjzMasWlPGWTyapmbFlqpWpTw6NWWjOmlpPGOWxTo5M6mqPMOVqVbMWWNWVVlllVqjXDyjxjxZaTxWXDw6U5aco1ysxmUzxmVcyarKllkzzFk8ZcM6Y1mWM5mVo8nKNsZprDPFrFlcOWNVqmY2NqlWxcNmWcxTrKaqXKZTxZzMZTk2k2NlzMPJWWNpaVWsk1bMqjqWbMxZZpZsNsqmWmU5VTyVWcpWOTZsrJU8qWZVOqqqacxWw1M=";
  String userShare64 =
      "vqfp7XW9xtm+3Km5dmvpfs3cPrl7t+rZNbN5u9Nz6napWunjmZw8w5U2UzY5WcVmmlZcw2amOsUzNZVpw2OWNjVso1NsOqmqxsWpZWbFpmVjPKNZOZlsmZo5OpVpaqxsNqbDyjlVnKZpyWY6XDM1yqmVM8qaU8ajrFY6VTXFyZapbDWZxjOqVVxTqszFOsNjVpbJXDqZVpw8llWmqqnJbMk5VcU5mTM2xclTyVw5PJqWnKNqpjapxsqTY2PDbJqsppVVmlallaw=";
  bool isCorrect = false;
  /*
  List<int> LoadSecret(List<int> Secret) {
    var Ret = List.filled(50, 0);
    for (int i = 0; i < 400; ++i) {
      Ret[i ~/ 8] |= Secret[i] << (i % 8);
    }
    return Ret;
  }

  List<int> LoadShare(List<int> Share, String mode) {
    var Img = List.generate(40, (i) => List.filled(40, 0, growable: false),
        growable: false);
    var Ret = List.filled(200, 0);
    for (int i = 0; i < 1600; ++i) {
      Img[i ~/ 40][i % 40] = Share[i];
    }
    for (int r = 0; r < 40; r += 2) {
      for (int c = 0; c < 40; c += 2) {
        int Idx = r * 5 + (c ~/ 4);
        for (int sh = 0; sh < 2; ++sh) {
          Ret[Idx] |= Img[r][c] << (sh * 4);
          Ret[Idx] |= Img[r][c + 1] << (sh * 4 + 1);
          Ret[Idx] |= Img[r + 1][c] << (sh * 4 + 2);
          Ret[Idx] |= Img[r + 1][c + 1] << (sh * 4 + 3);
          c += 2;
        }
        c -= 2;
      }
    }
    return Ret;
  }
  */
  //#################################################################
  Future<void> Submit(String name) async {
    ResponseFormat response = await HttpCreate(serverAdd, name);
    if (response.code == 200) {
      response.data['serverAdd'] = serverAdd;
      doneDialog('Door created!\nnow navigating to door...');
      Timer(const Duration(seconds: 2),
          () => Get.offNamed(Routes.NavBar, arguments: response.data));
    } else {
      if (response.code == -1) {
        NoHttpDialog(response.data['detail']);
        Timer(const Duration(seconds: 2),
            () => Get.offNamed(Routes.NavBar, arguments: ConvertData()));
      } else {
        ErrorDialog(response.data['code'], response.data['detail']);
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

  //  ConvertData is only a testing function
  Map<String, dynamic> ConvertData() {
    Map mp = {
      "secret": secret64,
      "share": doorShare64,
      "door_name": "abc",
      "serverAdd": serverAdd,
    };
    String encodedmp = json.encode(mp);
    Map<String, dynamic> ret = json.decode(encodedmp);
    return ret;
  }

  void setURL(String Ip, String port) {
    serverAdd = '$Ip:$port';
  }

  @override
  Widget build(BuildContext Context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Cropped.jpg"), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                      left: 35,
                      right: 35,
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Create\nA\nDoor',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Please give your new door a Name.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Note: Door Name cannot exceed 50 characters.',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: NameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Door Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              NameController.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(250, 70),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            side: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 89, 92, 93)),
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[700],
                                  child: const Icon(
                                    color: Colors.white,
                                    Icons.arrow_forward,
                                  )),
                            ],
                          ),
                          onPressed: () {
                            if (NameController.text.isEmpty) {
                              ErrorDialog('001', 'Name space cannot be empty');
                            }
                            var Name = NameController.text;
                            var encoded = utf8.encode(Name);
                            var NameLength = String.fromCharCodes(encoded).length;
                            if (NameLength > 50) {
                              ErrorDialog('002',
                                  'Name space cannot exceed more than 50 chars.');
                            } else {
                              //var ddd = Name.codeUnits;
                              //var b = utf8.decode(ddd);
                              Submit(Name);
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size(150, 50),
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          side: const BorderSide(
                              width: 2, color: Color.fromARGB(255, 89, 92, 93)),
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'SetPortIp',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Set Port Ip",
                              backgroundColor: Colors.grey[700],
                              titleStyle: const TextStyle(color: Colors.white),
                              middleTextStyle:
                                  const TextStyle(color: Colors.white),
                              radius: 30,
                              content: Column(children: [
                                TextField(
                                  controller: IpController,
                                  //keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: 'Ip',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        IpController.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: PortController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: 'Port',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        PortController.clear();
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    setURL(
                                        IpController.text, PortController.text);
                                    IpController.clear();
                                    PortController.clear();
                                    Get.back();
                                    doneDialog('Ip was set at: $serverAdd');
                                    closeDialogTimer(1);
                                  },
                                )
                              ]));
                        },
                      ),
                    ],
                  )),
            )));
  }
}
