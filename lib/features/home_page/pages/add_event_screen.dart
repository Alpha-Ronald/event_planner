import 'dart:developer';

import 'package:event_planner_app/core/textStyles.dart';
import 'package:event_planner_app/features/home_page/widgets/add_event_button.dart';
import 'package:event_planner_app/features/home_page/widgets/add_event_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/colors.dart';
import '../../../providers/theme_provider.dart';

class AddEventPage extends ConsumerStatefulWidget {
  const AddEventPage({super.key});

  @override
  ConsumerState<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _endTime = '9:30 PM';
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedReminder = 5;
  List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Scaffold(
      appBar: _appBar(isDarkMode),
      body: Container(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.w),
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
              AddEventInputField(
                title: 'Title',
                hint: 'Enter title here.',
                controller: _titleController,
              ),
              AddEventInputField(
                title: "Note",
                hint: "Enter note here.",
                controller: _noteController,
              ),
              AddEventInputField(
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
                    child: AddEventInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time_outlined),
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
                    child: AddEventInputField(
                      title: 'End Time',
                      hint: _endTime,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time_outlined),
                        onPressed: () {
                          _getTime(isStartTime: false);
                        },
                      ),
                      readOnly: true,
                    ),
                  )
                ],
              ),
              AddEventInputField(
                title: 'Remind',
                hint: '$_selectedReminder minutes early',
                readOnly: true,
                suffixIcon: DropdownButton<String>(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                  iconSize: 25,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedReminder = int.parse(newValue!);
                    });
                  },
                ),
              ),
              AddEventInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                readOnly: true,
                suffixIcon: DropdownButton<String>(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                  iconSize: 25,
                  elevation: 4,
                  underline: Container(
                    height: 0,
                  ),
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalete(),
                  AddEventButton(
                    buttonText: 'Create Task',
                    onTap: () {
                      _validateData();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      log('message');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'All fields are required',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  _colorPalete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0, top: 8.h),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                          ? pinkColor
                          : yellowColor,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  AppBar _appBar(bool isDarkMode) {
    return AppBar(
      automaticallyImplyLeading: true,
      //leading: Icon(Icons.arrow_back),
      elevation: 0,
      backgroundColor: isDarkMode ? Colors.black : veryLightBlue,
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

  _getTime({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (!mounted || pickedTime == null) return;

    String formattedTime = pickedTime.format(context);
    if (pickedTime! == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }
}
