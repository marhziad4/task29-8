

import 'package:flutter/material.dart';
import 'package:todo_emp/screen/to_do_ui/TodoMainPage.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff0f31dc),
        title: Text(
          'التقويم',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: TableCalendar(
        //   firstDay: DateTime.utc(2010, 10, 16),
        //   lastDay: DateTime.utc(2030, 3, 14),
        //   focusedDay: DateTime.now(),
        //   eventLoader: (day) {
        //     return _getEventsForDay(day);
        //   },
        // ),
      ),
    );
  }
  // List<Event> _getEventsForDay(DateTime day) {
  //   return events[day] ?? [];
  // }
}
