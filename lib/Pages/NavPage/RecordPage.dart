// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:door/DoorController/DoorRunning_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:door/Blocks/record.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  late DoorController door = Get.find<DoorController>();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusDay = DateTime.now();
  late final ValueNotifier<List<Record>> _selectedEvents;
  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsfromDay(_selectedDay));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusDay = focusedDay;
    });
    _selectedEvents.value = _getEventsfromDay(selectedDay);
  }

  List<Record> _getEventsfromDay(DateTime date) {
    String Date = DateFormat("MMMM-dd yyyy").format(date);
    return door.Maprecords[Date] ?? [];
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
            title: const Text('Record Page'),
          );
        },
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusDay,
            headerStyle: const HeaderStyle(
                titleCentered: true, formatButtonVisible: false),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsfromDay,
            calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) => events.isNotEmpty
                    ? Container(
                        width: 5.0,
                        height: 5.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Container()),
          )),
      const SizedBox(height: 8.0),
      Expanded(
        child: ValueListenableBuilder<List<Record>>(
          valueListenable: _selectedEvents,
          builder: (context, value, _) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(value[index].username),
                    subtitle: Text(value[index].time),
                  ),
                );
              },
            );
          },
        ),
      )
    ]);
  }
}
