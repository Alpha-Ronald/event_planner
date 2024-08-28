import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/features/authentication/widgets/create_account_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/textStyles.dart';
import '../../../utils/sign_up_method.dart';
import '../../../providers/theme_provider.dart';

class CreateAccountPage extends ConsumerWidget {
  CreateAccountPage({super.key, required this.signUpMethod});

  final SignUpMethod signUpMethod;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    String titleText =
        signUpMethod == SignUpMethod.email ? 'Email' : 'Phone Number';
    TextInputType inputType = signUpMethod == SignUpMethod.email
        ? TextInputType.emailAddress
        : TextInputType.phone;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: SingleChildScrollView(
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
                  CreateAccountField(
                    title: 'Username',
                    hintText: 'dav-06',
                    keyboardType: TextInputType.text,
                    controller: _userNameController,
                    inputLength: 10,
                  ),
                  CreateAccountField(
                      title: 'Full-name',
                      keyboardType: TextInputType.name,
                      hintText: "Surname  FirstName",
                      controller: _fullNameController,
                      inputLength: 20),
                  CreateAccountField(
                      controller: _genderController,
                      title: "Gender",
                      keyboardType: TextInputType.text,
                      hintText: "male",
                      inputLength: 6),
                  CreateAccountField(
                    controller: _emailController,
                    title: titleText,
                    keyboardType: inputType,
                    hintText: signUpMethod == SignUpMethod.email
                        ? "abc@gmail.com"
                        : "08123456789",
                    inputLength: signUpMethod == SignUpMethod.email ? 20 : 11,
                  ),
                  CreateAccountField(
                    controller: _passwordController,
                    title: "Password",
                    keyboardType: TextInputType.text,
                    hintText: "Av3*fs",
                    obscureText: true,
                    inputLength: 20,
                  ),
                  CreateAccountField(
                    controller: _confirmPasswordController,
                    title: "Confirm Password",
                    keyboardType: TextInputType.text,
                    hintText: "Av3*fs",
                    obscureText: true,
                    inputLength: 20,
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.h),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          fontWeight: titleStyle.fontWeight,
                          fontSize: titleStyle.fontSize,
                          color: Colors.white),
                    ),
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
