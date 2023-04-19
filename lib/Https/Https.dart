// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'HttpResponseFormat.dart';
import 'DoorURL.dart';

Future<ResponseFormat> HttpSubmitName(String serverAdd, String name) {
  Map map = {'doorName': name};
  return httpRequest(serverAdd, map, 'create');
}

Future<ResponseFormat> HttpDelete(String serverAdd, Map map) {
  return httpRequest(serverAdd, map, 'delete');
}

Future<ResponseFormat> HttpUpdate(String serverAdd, Map map) {
  return httpRequest(serverAdd, map, 'update');
}

Future<ResponseFormat> httpRequest(
    String serverAdd, Map map, String mode) async {
  try {
    var response = await http.post(Uri.http(serverAdd, DoorURL.URLs[mode]!),
        body: json.encode(map));
    print('had http');
    Map<String, dynamic> Data = jsonDecode(response.body);
    var Code = response.statusCode.toInt();
    return ResponseFormat(code: Code, data: Data);
  } catch (e) {
    print('no http');
    if (e is SocketException) {
      print("Socket exception: ${e.toString()}");
    } else if (e is TimeoutException) {
      print("Timeout exception: ${e.toString()}");
    } else {
      print("Unhandled exception: ${e.toString()}");
    }
    return ResponseFormat(code: -1, data: {});
  }
}
