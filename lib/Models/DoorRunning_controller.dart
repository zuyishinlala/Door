import 'package:get/get.dart';
import 'package:door/Door.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

class DoorController extends GetxController {
  Rx<String> Name = ''.obs;
  Rx<String> secret = 'secret'.obs;
  Rx<String> share = 'share'.obs;
  DoorController() {}
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  void SetDoor(Map<String, dynamic> json) {
    Name.value = json["doorName"];
    secret.value = stringToBase64.decode(json["secret"]);
    share.value = stringToBase64.decode(json["doorShare"]);
    update();
  }

  DoorController.fromJson(Map<String, dynamic> json) {
    Name.value = json["doorName"];
    secret.value = stringToBase64.decode(json["secret"]);
    share.value = stringToBase64.decode(json["doorShare"]);
    update();
  }
  /*
  Uint8List TransformData(String data) {
    var buffer = base64Decode(data);
  }
  */
  void UpdateDoor(Map<String, dynamic> json) {
    //TransformData(json['secret']);
    //TransformData(json['doorShare']);
  }
  Map<String, dynamic> UdateDoorRequest() {
    Map<String, dynamic> map = {'doorName': Name.value, 'secret': secret.value};
    return map;
  }

  Map<String, dynamic> DeleteDoorRequest() {
    Map<String, dynamic> map = {'doorName': Name.value, 'secret': secret.value};
    return map;
  }
}
