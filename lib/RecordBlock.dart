import 'package:flutter/material.dart';
import 'package:door/Record.dart';

class RecordBlock extends StatelessWidget {
  final Record record;
  final bool ShowDate;
  RecordBlock({required this.record, required this.ShowDate});
  @override
  Widget build(BuildContext context) { 
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowDate == true ? 
            Container(
              margin: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                '${record.Date}',
                style: TextStyle(
                  color : Color.fromARGB(255, 187, 165, 100),
                  fontSize: 25,
                  fontWeight: FontWeight.w800
                )
              )
            ): SizedBox.shrink(),
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.black12, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User : ${record.UserName}',
                      style: TextStyle(
                          color: Colors.grey[10],
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  Text('${record.Time}',
                      style: TextStyle(
                          color: Colors.grey[10],
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              )
            )
          ],
        )
    );
  }
}
