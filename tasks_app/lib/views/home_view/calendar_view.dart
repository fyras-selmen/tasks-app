import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasks_app/views/home_view/tasks_view.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Colors.deepPurple,
        ),
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          headerStyle: const HeaderStyle(
              formatButtonVisible: false, titleCentered: true),
          onDaySelected: (selected, focused) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TasksView(day: selected)));
          },
        ),
      ],
    );
  }
}
