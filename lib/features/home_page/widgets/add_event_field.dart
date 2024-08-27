import 'package:event_planner_app/core/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEventInputField extends StatelessWidget {
  const AddEventInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.suffixIcon,
      this.readOnly = false});

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
