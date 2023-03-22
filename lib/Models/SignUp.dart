import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'package:door/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController NameController = TextEditingController();
  String WaringMessage = '';
  Future<void> SubmitName(String name) async {
    if (NameController.text.isEmpty) {
      WaringMessage = 'Name box cannot be empty!';
      Timer.periodic(const Duration(seconds: 3), (timer) {
        setState(() {
          WaringMessage = '';
          timer.cancel();
        });
      });
    } else {
      var response = await http
          .post(Uri.http('serveraddress', '/api'), body: {'doorName': name});
      if (response.statusCode == 1) {
        //not created
        WaringMessage = 'Door name had been used.';
        Timer.periodic(const Duration(seconds: 3), (timer) {
          setState(() {
            WaringMessage = '';
            timer.cancel();
          });
        });
      } else {
        // getoff another screen
        // Pass data to another page
        var Data = jsonDecode(response.body) as Map<String, dynamic>;
        Get.offNamed(Routes.DoorRunning, arguments: Data);
        //created
      }
    }
  }

  Map<String, dynamic> ConvertData(String name) {
    return {
      "secret" : "MTIzNDU2Nw==", // 1234567
      "doorShare" : "NzY1NDMyMQ==", //7654321
      "doorName" :  name
    };
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
                        controller: NameController,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 40,
                        child: Text(
                          WaringMessage != ''
                              ? 'Warning : ${WaringMessage}'
                              : '',
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
                          Get.offNamed(Routes.DoorRunning,
                              arguments: ConvertData(NameController.text));
                        },
                      )
                    ],
                  )),
            )));
  }
}
