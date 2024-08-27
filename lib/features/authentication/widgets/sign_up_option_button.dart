import 'package:event_planner_app/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/theme_provider.dart';

class SignUpButton extends ConsumerWidget {
  const SignUpButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.icon,
      required this.color});

  final String text;
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                side:
                    BorderSide(color: isDarkMode ? primaryColor : Colors.white),
                borderRadius: BorderRadius.circular(30.r))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
