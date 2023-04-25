// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, curly_braces_in_flow_control_structures, file_names
import 'package:door/Https/Https.dart';
import 'package:door/Https/HttpResponseFormat.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:door/main.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:flutter/services.dart';

import '../PopUpDialog/ErrorDialog.dart';
import '../PopUpDialog/NohttpDialog.dart';

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

  Future<void> Submit(String name) async {
    ResponseFormat response = await HttpCreate(door.serverAdd, name);
    if (response.code == 200) {
      Get.offNamed(Routes.NavBar, arguments: response.data);
    } else {
      if (response.code == -1) {
        NoHttpDialog(response.data['reason']);
        Timer(const Duration(seconds: 2),
            () => Get.offNamed(Routes.NavBar, arguments: ConvertData(name)));
      } else {
        ErrorDialog(response.data['code'], response.data['reason']);
      }
    }
  }

  //  ConvertData is only a testing function
  Map<String, dynamic> ConvertData(String name) {
    var Share = base64Encode(Uint8List.fromList(List.filled(1, 165)));
    var Secret = base64Encode(Uint8List.fromList(List.filled(1, 30)));
    Map mp = {"secret": Secret, "doorShare": Share, "doorName": name};
    String encodedmp = json.encode(mp);
    Map<String, dynamic> ret = json.decode(encodedmp);
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
                      top: MediaQuery.of(context).size.height * 0.3),
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
                              ErrorDialog('001', 'Name space cannot be empty');
                            }
                            var encoded = utf8.encode(NameController.text);
                            var Name = String.fromCharCodes(encoded);
                            if (Name.length > 50) {
                              ErrorDialog('002',
                                  'Name space cannot exceed more than 50 chars.');
                            } else {
                              //var ddd = Name.codeUnits;
                              //var b = utf8.decode(ddd);
                              Submit(Name);
                            }
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
                                  /*
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  */
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
                                  /*
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  */
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
