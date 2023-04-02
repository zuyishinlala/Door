// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, curly_braces_in_flow_control_structures

import 'dart:io';

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
  void ErrorMessage(String code, String reason) {
    Get.defaultDialog(
        title: "Error!",
        backgroundColor: Colors.white,
        radius: 5,
        middleTextStyle: const TextStyle(fontSize: 18),
        middleText: 'Code Error: $code\nReason: $reason',
        textConfirm: 'Yes',
        buttonColor: Colors.amber,
        confirmTextColor: Colors.black26,
        onConfirm: () => Get.back());
  }

  Future<void> SubmitName(String name) async {
    try {
      print(door.serverAdd);
      Map map = {'doorName': name};
      var response = await http.post(Uri.https(door.serverAdd, DoorURL.create),
          body: json.encode(map));
      Map<String, dynamic> Data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //Door created
        print('had http');
        Get.offNamed(Routes.DoorScan, arguments: Data);
      } else {
        ErrorMessage(Data['code'], Data['reason']);
      }
    } catch (e) {
      if (e is SocketException) {
        print("Socket exception: ${e.toString()}");
      } else if (e is TimeoutException) {
        print("Timeout exception: ${e.toString()}");
      } else {
        print("Unhandled exception: ${e.toString()}");
      }
      print('No http');
      Get.offNamed(Routes.NavBar, arguments: ConvertData(name));
    }
  }

  Map<String, dynamic> ConvertData(String name) {
    var Share = base64Encode(Uint8List.fromList(List.filled(1, 165)));
    var Secret = base64Encode(Uint8List.fromList(List.filled(1, 30)));
    Map mp = {"secret": Secret, "doorShare": Share, "doorName": name};
    String encodedmp = json.encode(mp);
    Map<String, dynamic> ret = jsonDecode(encodedmp);
    return ret;
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
                              fontSize: 18, fontWeight: FontWeight.w700),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: NameController,
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
                      SizedBox(
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
                            // ignore: prefer_const_literals_to_create_immutables
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.black54,
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
                          ),
                          onPressed: () {
                            if (NameController.text.isEmpty) {
                              ErrorMessage('001', 'Name space cannot be empty');
                            } else if (NameController.text.length > 50) {
                              ErrorMessage('002',
                                  'Name space cannot exceed more than 50 chars.');
                            } else
                              SubmitName(NameController.text);
                          }),
                      SizedBox(
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
                        child: Text(
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
                              titleStyle: TextStyle(color: Colors.white),
                              middleTextStyle: TextStyle(color: Colors.white),
                              radius: 30,
                              content: Column(children: [
                                TextField(
                                  controller: IpController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
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
                                  keyboardType: TextInputType.number,
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
                                    door.SetURL(
                                        IpController.text, PortController.text);
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
