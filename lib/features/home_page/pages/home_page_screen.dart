import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/core/theme.dart';
import 'package:event_planner_app/features/home_page/widgets/add_task_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'add_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addEventBar(context),
          DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: DateTime.now(),
            selectionColor: primaryColor,
            selectedTextColor: Colors.white,
            dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey),
            ),
            onDateChange: (date) {
              _selectedDate = date;
            },
          ),
        ],
      ),
    );
  }
}

_appBar() {
  return AppBar(
    leading: Icon(Icons.light_mode),
    elevation: 0,
    backgroundColor: veryLightBlue,
    actions: [
      CircleAvatar(
        backgroundImage: AssetImage('images/my_image.jpg'),
      ),
      SizedBox(
        width: 20.w,
      )
    ],
  );
}

_addEventBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              "Today",
              style: headingStyle,
            ),
          ],
        ),
        AddEventButton(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const AddTaskPage();
              },
            ));
          },
          buttonText: '+ Add Event',
        )
      ],
    ),
  );
}
