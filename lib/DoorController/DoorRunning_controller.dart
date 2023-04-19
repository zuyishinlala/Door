// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, file_names

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:door/Pages/NavPage/RecordBlocks/Record.dart';
import 'package:intl/intl.dart';

List<Record> l = [
  Record('Daniel', '11:34:50'),
  Record('Daniel', '09:34:56'),
  Record('Daniel', '06:31:18'),
];

class DoorController extends GetxController {
  final Rx<String> _Name = ''.obs;
  Uint8List secret = Uint8List(0);
  Uint8List share = Uint8List(0);
  String serverAdd = '127.168.0.0.1:8000';
  var locked = true;

  // Fake Data
  Map<String, List<Record>> Maprecords = {
    'April-15 2023': l,
    'March-15 2023': l,
    'April-18 2023': l
  };
  void SetDoor(Map<String, dynamic> json) {
    Name(json["doorName"]);
    share = TransformShareData(base64Decode(json["doorShare"]));
    secret = TransformSecretData(base64Decode(json["secret"]));
  }

  void SetURL(String Ip, String port) {
    serverAdd = Ip + ':' + port;
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
      "doorName": _Name.value,
    };
  }

  void insertTempRecord(String Name) {
    String date = DateFormat("MMMM-dd yyyy").format(DateTime.now());
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    Record record = Record(Name, time);
    if (Maprecords[date] != null) {
      Maprecords[date]?.insert(0, record);
    } else {
      Maprecords[date] = [record];
    }
  }

  Uint8List getShare() => share;
  Uint8List getSecret() => secret;
  set Name(value) => _Name.value = value;
  get Name => _Name;
}
