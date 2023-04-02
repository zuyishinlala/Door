// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:door/Models/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:door/RecordBlock.dart';
import 'package:door/Record.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  late DoorController door = Get.find<DoorController>();
  /*
  Future getRecords() async {
    print('HaHa');
    List<Record> RecordList = await door.getRecord();
    return RecordList;
  }

  Widget RecordListView() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(
              child: Text('Currently, There are no door-opening records'));
        }
        return ListView.builder(
          itemCount: door.getRecordLen(),
          itemBuilder: (context, index) {
            Record r = projectSnap.data[index];
            return RecordBlock(record: r);
          },
        );
      },
      future: getRecords(),
    );
  }
  */
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
        GetBuilder<DoorController>(
          id: 'AppBar',
          builder: (door) {
            return AppBar(
              backgroundColor:
                  door.locked ? Colors.red[400] : Colors.green[400],
              title: const Text('Record Page'),
            );
          },
        ),
        const SizedBox(height:  10,),
        door.getRecord().isEmpty
        ? Text(
            'Currently, there are no door-opening records',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 25,
                fontWeight: FontWeight.w700))
        : Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: door.getRecordLen(),
              itemBuilder: (context, index) {
                List<Record> RecordList = door.getRecord();
                List<bool> ShowDate = List<bool>.filled(RecordList.length, true);
                String previousDate = '';
                for (int i = 0; i < RecordList.length ; ++i) {
                  if (previousDate == RecordList[i].Date) {
                    ShowDate[i] = false;
                  }
                  previousDate = RecordList[i].Date;
                }
                return RecordBlock(
                    record: RecordList[index], ShowDate : ShowDate[index]);
              },
            ),
          ),
    ]);
  }
}
