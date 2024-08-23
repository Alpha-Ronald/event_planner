import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpButton extends StatelessWidget{
  const SignUpButton({super.key, required this.text, required this.onPressed, required this.icon, required this.color});

  final String text;
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0,0,0,10.h),
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.h),
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

      ),
    );
  }
}