// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';

class DoorScanPage extends StatefulWidget {
  const DoorScanPage({Key? key}) : super(key: key);
  @override
  _DoorScanPageState createState() => _DoorScanPageState();
}

class _DoorScanPageState extends State<DoorScanPage> {
  late DoorController door = Get.find<DoorController>();
  late Timer _timer;
  DateTime? lastScan;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final seedQueue = Queue<int>();
  String HintString = 'Scan the QrCode below if you want to open the door.';
  late final ValueNotifier<String> _ShowedString = ValueNotifier<String>(
      'Scan the QrCode below if you want to open the door.');
  @override
  void initState() {
    super.initState();
    seedQueue.addLast(DateTime.now().millisecondsSinceEpoch);
    seedQueue.addLast(DateTime.now().millisecondsSinceEpoch + 10);
    _timer =
        Timer.periodic(const Duration(seconds: 60), (Timer t) => seedRefresh());
    lastScan = DateTime.now();
  }

  void seedRefresh() {
    setState(() {
      seedQueue.addLast(DateTime.now().millisecondsSinceEpoch);
      seedQueue.removeFirst();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final currentScan = DateTime.now();
      if (door.locked &&
          scanData.code != null &&
          currentScan.difference(lastScan!) > const Duration(seconds: 1)) {
        _ShowedString.value = 'User QR Code scanned!';
        Timer(const Duration(milliseconds: 500), (() {
          _ShowedString.value = HintString;
        }));
        Uint8List xorUserShare = base64Decode(scanData.code!);
        assert(xorUserShare.length == 200);
        bool isopen = false;
        for (int seedidx = 0; seedidx < 2; ++seedidx) {
          if (!isopen) {
            Uint8List TempUserShare = xorUserShare;
            Random random = Random(seedQueue.elementAt(seedidx));
            for (int i = 0; i < 200; i++) {
              TempUserShare[i] = TempUserShare[i] ^ random.nextInt(256);
            }
            if (!door.isblacklist(base64Encode(TempUserShare))) {
              String Username = '';
              Uint8List UserShare =
                  door.TransformShareData(TempUserShare); // Share Len : 400
              try {
                Username = GetUserName(UserShare);
              } catch (e) {
                Username = 'Cannot be decoded';
              }
              if (!isopen && isCorrectKey(UserShare)) {
                isopen = true;
                door.insertNameRecord(Username);
                door.unlock();
              }
            } else {
              _ShowedString.value = 'You are in the black list!';
              Timer(const Duration(milliseconds: 500), (() {
                _ShowedString.value = HintString;
              }));
            }
          }
        }
        lastScan = currentScan;
      }
    });
  }

  bool isCorrectKey(Uint8List UserShare) {
    assert(UserShare.length == 400);
    Uint8List DoorShare = door.share;
    Uint8List Secret = door.secret;
    for (int i = 0; i < 400; ++i) {
      var tmp = UserShare[i] | DoorShare[i];
      var count = 0;
      for (int shift = 0; shift < 4; ++shift) {
        if ((tmp >> shift & 1) == 1) ++count;
      }
      if (!((count == 3 && Secret[i] == 0) || (count == 4 && Secret[i] == 1))) {return false;}
    }
    return true;
  }

  String GetUserName(Uint8List UserShare) {
    List<int> UserName = List.filled(50, 0);
    int CountList = 0;
    for (int i = 0; i < 400; ++i) {
      var UserSubpixelCount = 0;
      for (int u = 0; u < 4; ++u) {
        if ((UserShare[i] >> u & 1) == 1) ++UserSubpixelCount;
      }
      assert(UserSubpixelCount == 2 || UserSubpixelCount == 3);
      UserName[i ~/ 8] |=
          (UserSubpixelCount == 2 ? 0 : 1) << (i % 8); //reverse: 7 - (i%8)
      if (i % 8 == 0) {
        ++CountList;
      }
      if (i == (CountList * 8 - 1) && UserName[i ~/ 8] == 0) {
        break;
      }
    }
    return utf8.decode(UserName.sublist(0, CountList - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GetBuilder<DoorController>(
        id: 'AppBar',
        builder: (door) {
          return AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: door.locked ? Colors.red[400] : Colors.green[400],
            title: Text(door.locked ? 'Locked' : 'Pass!'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  seedRefresh();
                },
              )
            ],
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
          child: ValueListenableBuilder<String>(
              builder: (context, value, child) {
                return Text(value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 208, 157, 6),
                        fontSize: 20,
                        fontWeight: FontWeight.w800));
              },
              valueListenable: _ShowedString)),
      Obx(
        () => SizedBox(
          height: 250,
          width: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: QrImage(
                data: "d=${door.Name}&s=${seedQueue.elementAt(1)}",
                version: 10,
                errorCorrectionLevel: QrErrorCorrectLevel.L,
              ),
            ),
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
    ]);
  }
}
