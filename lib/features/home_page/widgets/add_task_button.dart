import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/features/home_page/pages/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const AddTaskPage();
          },
        ));
      },
      child: Container(
        width: 100.w,
        height: 60.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: primaryColor),
        child: const Center(
          child: Text(
            '+ Add Event',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
