// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:door/main.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController NameController = TextEditingController();
  TextEditingController IpController = TextEditingController();
  TextEditingController PortController = TextEditingController();
  late DoorController door = Get.find<DoorController>();
  String WaringMessage = '';
  void ErrorMessage(String code, String reason) {
    Get.defaultDialog(
      radius: 5,
      middleText: 'Code Error: $code\nReason: $reason',
      middleTextStyle: TextStyle(fontSize: 15),
      backgroundColor: Colors.blue,
    );
    Timer(Duration(seconds: 2), () {
      Get.back();
    });
  }


  Future<void> SubmitName(String name) async {
    if (NameController.text.isEmpty) {
      WaringMessage = 'Name box cannot be empty!';
      Timer.periodic(const Duration(seconds: 3), (timer) {
        setState(() {
          WaringMessage = '';
          timer.cancel();
        });
      });
    }else {
      Map map = {'doorName': name};
      var response = await http.post(Uri.http(door.serverAdd, DoorURL.create),
          body: json.encode(map));
      var Data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        //Door created
        Get.offNamed(Routes.DoorScan, arguments: Data);
      } else {
        ErrorMessage(Data['code'], Data['reason']);
      }
    }
  }

  Map<String, dynamic> ConvertData(String name) {
    var Share = base64Encode(Uint8List.fromList(List.filled(1, 165)));
    var Secret = base64Encode(Uint8List.fromList(List.filled(1, 30)));
    return {"secret": Secret, "doorShare": Share, "doorName": name};
  }

  @override
  Widget build(BuildContext Context) {
    return Container(
        decoration: BoxDecoration(
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
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create\nA\nDoor',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please give your new door a Name.',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Note: Door Name cannot exceed 50 characters.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: NameController,
                        keyboardType: TextInputType.none,
                        style: TextStyle(color: Colors.black),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        child: Text(
                          WaringMessage != '' ? 'Warning : $WaringMessage' : '',
                          style: TextStyle(
                              color: Color.fromARGB(255, 222, 136, 116),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 190),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 200, 241, 233),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextButton(
                            onPressed: () {
                              SubmitName(NameController.text);
                            },
                            child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[700],
                                    child: Icon(
                                      color: Colors.white,
                                      Icons.arrow_forward,
                                    )),
                              ],
                            )),
                      ),
                      TextButton(
                        child: Text(
                          'GotoDoor',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 27,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          Get.offNamed(Routes.NavBar,
                              arguments: ConvertData(NameController.text));
                        },
                      ),
                      TextButton(
                        child: Text(
                          'SetPortIp',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          Get.defaultDialog(
                              title: "Set Port Ip",
                              backgroundColor: Colors.grey[700],
                              titleStyle: TextStyle(color: Colors.white),
                              middleTextStyle: TextStyle(color: Colors.white),
                              radius: 30,
                              content: Column(children: [
                                TextField(
                                  controller: IpController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                                  ],
                                  style: TextStyle(color: Colors.black),
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
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: PortController,
                                  keyboardType : TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  style: TextStyle(color: Colors.black),
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
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  onPressed: () {
                                    door.SetURL(IpController.text, PortController.text);
                                    Get.back();
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
