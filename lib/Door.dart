import 'package:flutter/foundation.dart';
import 'dart:convert';

class Door {
  late String Name;
  late Uint8List secret;
  late Uint8List share;
  Door.fromJson(Map<String, dynamic> json) {
    Name = json["doorName"];
    secret = TransformData(base64Decode(json["secret"]));
    share = TransformData(base64Decode(json["doorShare"]));
  }
  Uint8List TransformData(Uint8List data) {
    final buffer = data //buffer2 had done XOR that passed back
        .map(
          (e) {
            final tmp = List.filled(8, 0);
            for (int i = 0; i < 8; i++) {
              tmp[i] = (e >> i) & 1;
            }
            return tmp;
          },
        )
        .expand((e) => e)
        .toList();
    return Uint8List.fromList(buffer);
  }
  
}
