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
  Record('John', '09:34:56'),
  Record('Dennis', '06:31:18'),
];

class DoorController extends GetxController {
  final Rx<String> _Name = ''.obs;
  Uint8List secret = Uint8List(0); // 400
  Uint8List share = Uint8List(0); // 400
  String serverAdd = '';
  List<String> blacklist = [];
  var updates = <Updateblock>[].obs;
  var locked = true;
  // Fake Data
  Map<String, List<Record>> Maprecords = {
    'April-15 2023': l,
    'March-15 2023': l,
    'April-18 2023': l
  };

  void SetDoor(Map<String, dynamic> json) {
    var Tempname1 = json["door_name"].codeUnits;
    String Temp = utf8.decode(Tempname1);
    _Name.value = Temp;
    share = TransformShareData(base64Decode(json["share"]));
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

  void UpdateDoor(String share64, String secret64) {
    share = TransformShareData(base64Decode(share64));
    secret = TransformSecretData(base64Decode(secret64));
  }

  Map<String, dynamic> DoorRequest() {
    var SecretBuffer = Uint8List(50);
    for (int i = 0; i < secret.length; ++i) {
      SecretBuffer[i ~/ 8] |= (secret[i] << (i % 8));
    }
    String base64encodedSecret = base64Encode(SecretBuffer);
    return {
      "secret": base64encodedSecret,
    };
  }

  void insertNameRecord(String Name) {
    String date = DateFormat("MMMM-dd yyyy").format(DateTime.now());
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    Record record = Record(Name, time);
    if (Maprecords[date] != null) {
      Maprecords[date]?.insert(0, record);
    } else {
      Maprecords[date] = [record];
    }
  }

  void insertUpdates(String mode) {
    String date = DateFormat("yyyy MMMM-dd").format(DateTime.now());
    String time = DateFormat("HH:mm:ss").format(DateTime.now());
    bool showdate = false;
    if (updates.isEmpty || updates[updates.length - 1].date != date) {
      // show date
      showdate = true;
    }
    updates.add(Updateblock(mode, date, time, showdate));
  }

  bool isblacklist(String UserShare) {
    return blacklist.contains(UserShare);
  }
  get Name => _Name.value;
}

//user = TransformShareData(decodedUser);
    /*
    List<int> UserName = List.filled(50, 0);
    int countLen = 0;
    for (int i = 0; i < 400; ++i) {
      var count = 0;
      for (int shift = 0; shift < 4; ++shift) {
        if ((user[i] >> shift & 1) == 1) ++count;
      }
      assert(count == 2 || count == 3);
      UserName[i ~/ 8] |= (count == 2 ? 0 : 1) << (i % 8);
      if (i % 8 == 0) {
        ++countLen;
      }
      if (i == (countLen * 8 - 1) && UserName[i ~/ 8] == 0) {
        break;
      }
    }
    var TempUserName = utf8.decode(UserName.sublist(0, countLen - 1));
    print('User Name is ---$TempUserName---');
    List<int> DoorName = List.filled(50, 0);
    int countDoorLen = 0;
    for (int i = 0; i < 400; ++i) {
      var count = 0;
      for (int shift = 0; shift < 4; ++shift) {
        if ((share[i] >> shift & 1) == 1) ++count;
      }
      assert(count == 2 || count == 3);
      DoorName[i ~/ 8] |= (count == 2 ? 0 : 1) << (i % 8);
      if (i % 8 == 0) {
        ++countDoorLen;
      }
      if (i == (countDoorLen * 8 - 1) && DoorName[i ~/ 8] == 0) {
        break;
      }
    }
    var TempDoorName = utf8.decode(DoorName.sublist(0, countDoorLen - 1));
    print('Door Name is ---$TempDoorName---');
    print('nooo');
    for (int i = 0; i < 400; ++i) {
      var tmp = share[i] | user[i];
      var count = 0;
      for (int shift = 0; shift < 4; ++shift) {
        if ((tmp >> shift & 1) == 1) ++count;
      }
      assert((count == 3 && secret[i] == 0) || (count == 4 && secret[i] == 1));
    }
    print('Ya');
    */