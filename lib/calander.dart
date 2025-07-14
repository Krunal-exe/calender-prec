import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  late CalendarController _calendarController;
  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _appointments = _getDataSource();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'July, 2025',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _showAddGroupDialog(context),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SfCalendar(
          view: CalendarView.month,
          controller: _calendarController,
          dataSource: MeetingDataSource(_appointments),
          initialDisplayDate: DateTime(2025, 7, 14),

          headerStyle: const CalendarHeaderStyle(
            backgroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 0),
          ),

          viewHeaderStyle: const ViewHeaderStyle(
            backgroundColor: Colors.white,
            dayTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),

          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: false,
            appointmentDisplayCount: 3,
            showTrailingAndLeadingDates: false,
            monthCellStyle: MonthCellStyle(
              backgroundColor: Colors.white,
              textStyle: TextStyle(fontSize: 16, color: Colors.black),
              leadingDatesTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              trailingDatesTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),

          todayHighlightColor: Colors.purple,

          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),

          cellBorderColor: Colors.grey.withOpacity(0.3),

          showNavigationArrow: false,
          showDatePickerButton: false,

          allowViewNavigation: false,

          // Set selected date to match screenshot (18th)
          initialSelectedDate: DateTime(2025, 7, 18),
        ),
      ),
    );
  }

  List<Appointment> _getDataSource() {
    final List<Appointment> meetings = <Appointment>[];

    meetings.add(
      Appointment(
        startTime: DateTime(2025, 7, 18),
        endTime: DateTime(2025, 7, 25),
        subject: '',
        color: Colors.brown,
        isAllDay: true,
      ),
    );

    meetings.add(
      Appointment(
        startTime: DateTime(2025, 7, 20),
        endTime: DateTime(2025, 7, 24),
        subject: '',
        color: Colors.brown,
        isAllDay: true,
      ),
    );

    return meetings;
  }

  void _showAddGroupDialog(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  startDate == null
                      ? 'Select Start Date'
                      : 'Start: ${startDate!.day}/${startDate!.month}/${startDate!.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setDialogState(() {
                      startDate = date;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  endDate == null
                      ? 'Select End Date'
                      : 'End: ${endDate!.day}/${endDate!.month}/${endDate!.year}',
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setDialogState(() {
                      endDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Color: '),
                  const SizedBox(width: 10),
                  ...([
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                    Colors.orange,
                    Colors.purple,
                    Colors.brown,
                  ].map(
                    (color) => GestureDetector(
                      onTap: () => setDialogState(() => selectedColor = color),
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  _addGroup(startDate!, endDate!, selectedColor);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Group'),
            ),
          ],
        ),
      ),
    );
  }

  void _addGroup(DateTime startDate, DateTime endDate, Color color) {
    setState(() {
      _appointments.add(
        Appointment(
          startTime: startDate,
          endTime: endDate,
          subject: '',
          color: color,
          isAllDay: true,
        ),
      );
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

// class SchedulerPage extends StatelessWidget {
//   const SchedulerPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scheduler')),
//       body: SfCalendar(
//         view: CalendarView.month,
//         dataSource: MeetingDataSource(_getDataSource()),
//         monthViewSettings: MonthViewSettings(
//           appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
//           showAgenda: false,
//         ),
//         todayHighlightColor: Colors.purple,
//         selectionDecoration: BoxDecoration(
//           color: Colors.purple.withOpacity(0.2),
//           border: Border.all(color: Colors.purple, width: 2),
//           borderRadius: BorderRadius.circular(4),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 1,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Scheduler',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//           BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Expenses'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   List<Appointment> _getDataSource() {
//     final List<Appointment> meetings = <Appointment>[];

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 18),
//         endTime: DateTime(2025, 7, 25),
//         subject: 'Brown Task',
//         color: Colors.brown,
//         isAllDay: true,
//       ),
//     );

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 18),
//         endTime: DateTime(2025, 7, 25),
//         subject: 'Green Task',
//         color: Colors.green,
//         isAllDay: true,
//       ),
//     );

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 18),
//         endTime: DateTime(2025, 7, 25),
//         subject: 'Blue Task',
//         color: Colors.blue,
//         isAllDay: true,
//       ),
//     );

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 20),
//         endTime: DateTime(2025, 7, 24),
//         subject: 'Long Brown Task',
//         color: Colors.brown,
//         isAllDay: true,
//       ),
//     );

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 20),
//         endTime: DateTime(2025, 7, 29),
//         subject: 'Long Green Task',
//         color: Colors.green,
//         isAllDay: true,
//       ),
//     );

//     meetings.add(
//       Appointment(
//         startTime: DateTime(2025, 7, 20),
//         endTime: DateTime(2025, 7, 27),
//         subject: 'Long Blue Task',
//         color: Colors.blue,
//         isAllDay: true,
//       ),
//     );

//     return meetings;
//   }
// }

// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }

// import 'package:calanderprec/calenderModel.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class CalenderScreen extends StatefulWidget {
//   const CalenderScreen({super.key});

//   @override
//   State<CalenderScreen> createState() => _CalenderScreenState();
// }

// class _CalenderScreenState extends State<CalenderScreen> {
//   List<DateRange> _selectedRanges = [];
//   final List<Color> _colors = [Colors.brown, Colors.green, Colors.blue];
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _tempStart;
//   DateTime? _tempEnd;
//   // final List<Color> _color = [Colors.green, Colors.red, Colors.blue];

//   void _configDateRange(DateTime? start, DateTime? end, DateTime focusedDay) {
//     if (start != null && end != null && _selectedRanges.length < 3) {
//       setState(() {
//         _selectedRanges.add(
//           DateRange(
//             start: start,
//             end: end,
//             color: _colors[_selectedRanges.length],
//           ),
//         );
//         _tempStart = null;
//         _tempEnd = null;
//         _focusedDay = focusedDay;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TableCalendar(
//             focusedDay: _focusedDay,
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2100, 1, 1),
//             headerStyle: HeaderStyle(formatButtonVisible: false),
//             rangeSelectionMode: RangeSelectionMode.toggledOn,
//             rangeStartDay: _tempStart,
//             rangeEndDay: _tempEnd,
//             onRangeSelected: (start, end, focusedDay) {
//               setState(() {
//                 _tempStart = start;
//                 _tempEnd = end;
//               });
//               if (start != null && end != null) {
//                 _configDateRange(start, end, focusedDay);
//               }
//             },
//             calendarBuilders: CalendarBuilders(
//               // defaultBuilder: (context, day, focusedDay) {
//               //   for (final range in _selectedRanges) {
//               //     if (!day.isBefore(range.start) && !day.isAfter(range.end)) {
//               //       return Container(
//               //         alignment: Alignment.center,
//               //         decoration: BoxDecoration(
//               //           color: range.color.withOpacity(0.25),
//               //           borderRadius: BorderRadius.circular(10),
//               //         ),
//               //         child: Text(
//               //           '${day.day}',
//               //           style: TextStyle(color: Colors.white),
//               //         ),
//               //       );
//               //     }
//               //   }
//               //   return null;
//               // },
//               rangeHighlightBuilder: (context, day, focusedDay) {
//                 for (final range in _selectedRanges) {
//                   if (!day.isBefore(range.start) && !day.isAfter(range.end)) {
//                     return Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: range.color.withOpacity(0.25),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         '${day.day}',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     );
//                   }
//                 }
//               },
//             ),
//           ),
//           // Text('start date : $_startDate'),
//           // Text('End date: $_endDate'),
//         ],
//       ),
//     );
//   }
// }
