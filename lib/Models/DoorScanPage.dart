// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:door/Models/DoorRunning_controller.dart';


class DoorScanPage extends StatefulWidget {
  const DoorScanPage({Key? key}) : super(key: key);
  @override
  _DoorScanPageState createState() => _DoorScanPageState();
}

class _DoorScanPageState extends State<DoorScanPage> {
  late DoorController door = Get.find<DoorController>();
  late Timer _timer;
  // bool _locked = true;

  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int currentSeed = 0;

  @override
  void initState() {
    super.initState();
    //getData();
    seedRefresh();
    _timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => seedRefresh());
  }

  Future<void> getData() async {
    final map = await Get.arguments;
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

  bool isCorrectKey(Uint8List xorUserShare) {
    Uint8List DoorShare = door.getShare();
    Uint8List Secret = door.getSecret();
    Random random = Random(currentSeed);
    for (int i = 0; i < 200; i++) {
      xorUserShare[i] = xorUserShare[i] ^ random.nextInt(256);
    }
    Uint8List UserShare = door.TransformShareData(xorUserShare);
    for (int i = 0; i < 400; ++i) {
      var tmp = UserShare[i] | DoorShare[i];
      var count = 0;
      for (int shift = 0; shift < 4; ++shift) {
        if ((tmp >> shift & 1) == 1) ++count;
      }
      if (!((count == 3 && Secret[i] == 0) || (count == 4 && Secret[i] == 1)))
        return false;
    }
    return true;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (door.locked.value &&
          scanData.code != null &&
          isCorrectKey(base64Decode(scanData.code!))) {
        setState(() {
          door.locked.value = false;
        });
        Timer.periodic(const Duration(seconds: 3), (timer) {
          setState(() {
            door.locked.value = true;
            timer.cancel();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      GetBuilder<DoorController>(
        id: 'AppBar',
        builder: (door) {
          return AppBar(
            backgroundColor:
                door.locked.value ? Colors.red[400] : Colors.green[400],
            title: Text(door.locked.value ? 'Locked' : 'Pass!'),
          );
        },
      ),
      Text('Scan the QrCode below if you want to open the door.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromARGB(255, 208, 157, 6),
              fontSize: 20,
              fontWeight: FontWeight.w800)),
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
      Expanded(
        child: QRView(
          key: qrKey,
          cameraFacing: CameraFacing.front,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            // full screen
            borderColor: Theme.of(context).primaryColor,
            borderRadius: 0,
            borderLength: 0,
            borderWidth: 0,
            cutOutWidth: MediaQuery.of(context).size.width,
            cutOutHeight: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    ]));
  }
}
