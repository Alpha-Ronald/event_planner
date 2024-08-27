import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/features/authentication/widgets/create_account_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../providers/theme_provider.dart';

class CreateAccountPage extends ConsumerWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            width: 320.w,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: primaryColor),
              color: isDarkMode ? Colors.black26 : Colors.white,
              borderRadius: BorderRadius.circular(35.r),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
                  blurRadius: 15.r,
                  offset: const Offset(5, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'CREATE YOUR ACCOUNT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Text(
                    'Create your personalized account and keep track of all your events',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20.h),
                  // CreateAccountField(title: '', label: '', keyboardType: null, hintText: '',),
                  const CreateAccountField(
                    title: 'Username',
                    hintText: 'dav-06',
                    keyboardType: TextInputType.text,
                  ),
                  CreateAccountField(
                      title: 'Full-name',
                      keyboardType: TextInputType.name,
                      hintText: "Surname  FirstName"),
                  CreateAccountField(
                      title: "Gender",
                      keyboardType: TextInputType.text,
                      hintText: "male"),
                  CreateAccountField(
                      title: "Email",
                      keyboardType: TextInputType.emailAddress,
                      hintText: "abc@gmail.com"),
                  const CreateAccountField(
                    title: "Password",
                    keyboardType: TextInputType.text,
                    hintText: "Av3*fs",
                    obscureText: true,
                  ),
                  const CreateAccountField(
                    title: "Confirm Password",
                    keyboardType: TextInputType.text,
                    hintText: "",
                    obscureText: true,
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.h),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
