// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, file_names

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:door/Blocks/record.dart';
import 'package:intl/intl.dart';
import '../Blocks/updateblock.dart';

List<Record> l = [
  Record('Daniel', '11:34:50'),
  Record('Daniel', '09:34:56'),
  Record('Daniel', '06:31:18'),
];

class DoorController extends GetxController {
  final Rx<String> _Name = ''.obs;
  Uint8List secret = Uint8List(0); // 400
  Uint8List share = Uint8List(0);  // 400
  String serverAdd = '';
  List<String> BlackList = [];
  var updates = <Updateblock>[].obs;
  var locked = true;

  // Fake Data
  Map<String, List<Record>> Maprecords = {
    'April-15 2023': l,
    'March-15 2023': l,
    'April-18 2023': l
  };

  void SetDoor(Map<String, dynamic> json) {
    var Tempname1 = json["doorName"].codeUnits;
    String Temp = utf8.decode(Tempname1);
    _Name.value = Temp;
    share = TransformShareData(base64Decode(json["doorShare"]));
    secret = TransformSecretData(base64Decode(json["secret"]));
    serverAdd = json["serverAdd"];
    insertUpdates('Door Created');
  }

  unlock() {
    locked = false;
    Timer.periodic(const Duration(seconds: 5), (timer) {
      locked = true;
      update(['AppBar']);
      timer.cancel();
    });
    update(['AppBar']);
  }

  Uint8List TransformShareData(Uint8List data) {
    var buffer = data
        .map((e) {
          var tmp = List.filled(2, 0);
          for (int i = 0; i < 2; ++i) {
            tmp[i] = (e >> (4 * i)) & 15;
          }
          return tmp;
        })
        .expand((e) => e)
        .toList();
    return Uint8List.fromList(buffer);
  }

  Uint8List TransformSecretData(Uint8List data) {
    var buffer = data
        .map((e) {
          final tmp = List.filled(8, 0);
          for (int idx = 0; idx < 8; idx++) {
            tmp[idx] = (e >> idx) & 1;
          }
          return tmp;
        })
        .expand((e) => e)
        .toList();
    return Uint8List.fromList(buffer);
  }

  void UpdateDoor(Map<String, dynamic> json) {
    share = TransformShareData(base64Decode(json["doorShare"]));
    secret = TransformSecretData(base64Decode(json["secret"]));
  }

  Map<String, dynamic> DoorRequest() {
    var SecretBuffer = Uint8List(50);
    for (int i = 0; i < secret.length; ++i) {
      SecretBuffer[i ~/ 8] |= (secret[i] << (i % 8));
    }
    String base64encodedSecret = base64Encode(SecretBuffer);
    return {
      "secret": base64encodedSecret,
      "doorName": NameEncode(_Name.value),
    };
  }

  void insertNameRecord(String Name) {
    String date = DateFormat("yyyy MMMM-dd").format(DateTime.now());
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    Record record = Record(Name, time);
    if (Maprecords[date] != null) {
      Maprecords[date]?.insert(0, record);
    } else {
      Maprecords[date] = [record];
    }
  }

  void insertUpdates(String mode) {
    String date = DateFormat("MMMM-dd yyyy").format(DateTime.now());
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    bool showdate = false;
    if (updates.isEmpty || updates[updates.length - 1].date != date) {       // show date
      showdate = true;
    }
    updates.add(Updateblock(mode, date, time, showdate));
  }

  get Name => _Name.value;
  String NameEncode(String name) {
    var encoded = utf8.encode(name);
    return String.fromCharCodes(encoded);
  }
}
