// ignore_for_file: non_constant_identifier_names, avoid_print, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'HttpResponseFormat.dart';
import 'DoorURL.dart';

FutureOr<http.Response> onTimeout() => http.Response(json.encode({}), 408);

Future<ResponseFormat> HttpCreate(String serverAdd, String name) {
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
    var response = await http
        .post(Uri.http(serverAdd, DoorURL.URLs[mode]!), body: json.encode(map))
        .timeout(
          const Duration(seconds: 5),
          onTimeout: onTimeout,
        );
    var Code = response.statusCode.toInt();
    Map<String, dynamic> Data = jsonDecode(response.body);
    Map<String, dynamic> Retmp = ToMap(Code, Data);
    return ResponseFormat(code: Code, data: Retmp);
  } catch (e) {
    String reason;
    int StatusCode = -2;
    if (e is SocketException) {
      StatusCode = -1;
      reason = "Socket exception: ${e.toString()}";
    } else if (e is TimeoutException) {
      reason = "Timeout exception: ${e.toString()}";
    } else {
      reason = "Unhandled exception: ${e.toString()}";
    }
    Map<String, dynamic> Retmp = ToMap(StatusCode, {"reason": reason});
    print('Wtf Mode is:$mode');
    return ResponseFormat(code: StatusCode, data: Retmp);
  }
}

Map<String, dynamic> ToMap(int StatusCode, Map<String, dynamic> data) {
  switch (StatusCode) {
    case 200:
      return data;
    case 400:
      return {
        "code": '$StatusCode-${data['code']}', // Ex: 200-1,
        "reason": data["reason"]
      };
    case 408:
      return {"code": '$StatusCode', "reason": 'Has http but http Timeout'};
    default:
      return {"code": '$StatusCode', "reason": data["reason"]};
  }
}
