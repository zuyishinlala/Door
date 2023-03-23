import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

class DoorController extends GetxController {
  Rx<String> Name = ''.obs;
  Uint8List secret = Uint8List(0);
  Uint8List share = Uint8List(0);
  String Haha = 'Door';
  late List<String> records;
  DoorController() {}
  void SetDoor(Map<String, dynamic> json) {
    Name.value = json["doorName"];
    share = TransformShareData(base64Decode(json["doorShare"]));
    secret = TransformSecretData(base64Decode(json["secret"]));
  }

  DoorController.fromJson(Map<String, dynamic> json) {
    Name.value = json["doorName"];
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
    for (int i = 0 ; i < secret.length ; ++i) {
      SecretBuffer[i ~/ 8] |= (secret[i] << (i % 8));
    }
    String base64encodedSecret = base64Encode(SecretBuffer);
    return {
      "secret": base64encodedSecret,
      "doorName": Name.value,
    };
  }

  Uint8List getShare() => share;
  Uint8List getSecret() => secret;
  String getHaha() => Haha;
}
