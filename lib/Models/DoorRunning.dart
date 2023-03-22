import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:door/main.dart';

class DoorRunning extends StatefulWidget {
  const DoorRunning({Key? key}) : super(key: key);
  @override
  _DoorRunningState createState() => _DoorRunningState();
}

class _DoorRunningState extends State<DoorRunning> {
  late DoorController door = Get.find<DoorController>();
  late Timer _timer;
  bool _locked = true;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int currentSeed = 0;

  @override
  void initState() {
    super.initState();
    getData();
    seedRefresh();
    _timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => seedRefresh());
  }

  Future<void> getData() async {
    final map = await Get.arguments;
    print(map);
    print('printed');
    //door = DoorController.fromJson(map);
    setState(() {
      door.SetDoor(map);
    });
  }

  void seedRefresh() {
    setState(() {
      currentSeed = DateTime.now().millisecondsSinceEpoch;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  /*
  bool isCorrectKey(Uint8List xorShare2) {
    Uint8List share1 = door.getShare1();
    if(xorShare2.length != share1.length){
      return false;
    }

    Random random = Random(currentSeed);
    Uint8List share2 = Uint8List(200);
    for(int i = 0; i < 200; i++){
      share2[i] = xorShare2[i] ^ random.nextInt(256);
    }

    String cover2 = to20x20Binaries(share2);
    if(door.isForbidden(cover2)){
      return false;
    }

    Uint8List covered = Uint8List(200);
    for(int i = 0; i < 200; i++){
      covered[i] = share1[i] & share2[i];
    }

    String tmpSecret = to20x20Binaries(covered);
    if(tmpSecret == door.getSecret()){
      door.addCover2(cover2);
      return true;
    }
    return false;
  }
  */
  String to20x20Binaries(Uint8List uint8list) {
    List<String> rows = List.filled(40, "");
    for (int row = 0; row < 40; row++) {
      for (int byte = 0; byte < 5; byte++) {
        rows[row] += uint8list[5 * row + byte].toRadixString(2).padLeft(8, "0");
      }
    }

    String binaries = "";
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 20; j++) {
        int blackCount = 0;
        blackCount += rows[i * 2][j * 2] == "0" ? 1 : 0;
        blackCount += rows[i * 2][j * 2 + 1] == "0" ? 1 : 0;
        blackCount += rows[i * 2 + 1][j * 2] == "0" ? 1 : 0;
        blackCount += rows[i * 2 + 1][j * 2 + 1] == "0" ? 1 : 0;
        binaries += blackCount == 4 ? "0" : "1";
      }
    }

    return binaries;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    //this.controller?.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      /*
      if(_locked && scanData.code != null &&
          isCorrectKey(base64Decode(scanData.code!))){
        setState(() {
          _locked = false;
        });
        Timer.periodic(const Duration(seconds: 3), (timer) {
          setState(() {
            _locked = true;
            timer.cancel();
          });
        });
      }
      */
      setState(() {
        _locked = false;
      });
      Timer.periodic(const Duration(seconds: 3), (timer) {
        setState(() {
          _locked = true;
          timer.cancel();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _locked
            ? AppBar(
                backgroundColor: Colors.red[400],
                title: const Text(
                  "Locked",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              )
            : AppBar(
                backgroundColor: Colors.green[400],
                title: const Text(
                  "Pass!",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 300,
              width: 300,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: QrImage(
                  data: "d=${door.Name.value}&s=$currentSeed",
                  version: 10,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                ),
              ),
            ),
            Text(
              '${door.Name.value}',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              '${door.share.value}',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              '${door.secret.value}',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            TextButton(
              child: Text(
                'RecordPage',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 27,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Get.toNamed(Routes.Record);
              },
            ),
            TextButton(
              child: Text(
                'DoorNamePage',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 27,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                Get.toNamed(Routes.ShowName);
              },
            )
            /*
            Container(
              height: 300,
              width: 300,
              child: QRView(
                key: qrKey,
                cameraFacing: CameraFacing.front,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderWidth: 20,
                  borderLength: 10,
                  cutOutSize: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            */
          ],
        ));
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
