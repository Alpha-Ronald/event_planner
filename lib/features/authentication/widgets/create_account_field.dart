import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/textStyles.dart';

class CreateAccountField extends StatelessWidget {
  const CreateAccountField(
      {super.key,
      required this.title,
      required this.label,
      required this.keyboardType,
      required this.hintText});

  final String title;
  final String label;
  final TextInputType keyboardType;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: titleStyle),
        SizedBox(
          height: 5.h,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
