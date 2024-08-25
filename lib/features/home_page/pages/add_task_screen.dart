import 'dart:developer';

import 'package:event_planner_app/core/theme.dart';
import 'package:event_planner_app/features/home_page/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/colors.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Event',
                style: headingStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              const TextInputField(title: 'Title', hint: 'Enter title here.'),
              const TextInputField(title: "Note", hint: "Enter note here."),
              TextInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                readOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () {
                    _getDate();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time_outlined),
                        onPressed: () {
                          _getTime(isStartTime: true);
                        },
                      ),
                      readOnly: true,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: TextInputField(
                      title: 'End Time',
                      hint: _endTime,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.access_time_outlined),
                        onPressed: () {
                          _getTime(isStartTime: false);
                          ;
                        },
                      ),
                      readOnly: true,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      //leading: Icon(Icons.arrow_back),
      elevation: 0,
      backgroundColor: veryLightBlue,
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage('images/my_image.jpg'),
        ),
        SizedBox(
          width: 20.w,
        )
      ],
    );
  }

  _getDate() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    } else {}
  }

  _getTime({required bool isStartTime}) {
    var pickedTime = _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime! == null) {
    } else if (isStartTime == true) {
      _startTime = _formattedTime;
    } else if (isStartTime == false) {
      _endTime = _formattedTime;
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(hour: 9, minute: 00));
  }
}
