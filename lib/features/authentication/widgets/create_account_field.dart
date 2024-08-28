import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/textStyles.dart';

class CreateAccountField extends StatelessWidget {
  const CreateAccountField(
      {super.key,
      required this.title,
      required this.keyboardType,
      required this.hintText,
      this.obscureText = false,
      this.controller,
      required this.inputLength});

  final String title;

  final TextInputType keyboardType;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final int inputLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          SizedBox(
            height: 5.h,
          ),
          TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(inputLength),
              // Adjust the maximum length as needed
            ],
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: controller,
          ),
        ],
      ),
    );
  }
}
