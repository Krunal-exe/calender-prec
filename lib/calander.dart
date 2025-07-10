import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  // final List<Color> _color = [Colors.green, Colors.red, Colors.blue];

  void _configDateRange(DateTime? start, DateTime? end, DateTime focusedDate) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _selectedDate = focusedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TableCalendar(
            focusedDay: _selectedDate,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 1, 1),
            headerStyle: HeaderStyle(formatButtonVisible: false),
            rangeStartDay: _startDate,
            rangeEndDay: _endDate,
            onRangeSelected: _configDateRange,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            calendarBuilders: CalendarBuilders(),
          ),
          Text('start date : $_startDate'),
          Text('End date: $_endDate'),
        ],
      ),
    );
  }
}
