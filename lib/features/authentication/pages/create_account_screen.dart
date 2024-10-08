import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/features/authentication/pages/verification_&_otp_screen.dart';
import 'package:event_planner_app/features/authentication/widgets/create_account_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/textStyles.dart';
import '../../../services/firbase_auth.dart';
import '../../../utils/sign_up_method.dart';
import '../../../providers/theme_provider.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  final SignUpMethod signUpMethod;

  const CreateAccountPage({super.key, required this.signUpMethod});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signUpPhone(BuildContext context) async {
    if (!_validateInfo(context)) return;

    final username = _userNameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final gender = _genderController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.signUpWithPhoneNumber(
        phoneNumber: phoneNumber,
        username: username,
        fullName: fullName,
        gender: gender,
        codeSentCallback: (verificationId) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return VerificationScreen(
                signUpMethod: SignUpMethod.phoneNumber,
                verificationId: verificationId,
                // Pass verificationId to next screen
                username: username,
                fullName: fullName,
                gender: gender,
              );
            },
          ));
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send OTP: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _signUpPhone(BuildContext context) async {
  //   if (!_validateInfo(context)) return;
  //
  //   final username = _userNameController.text.trim();
  //   final fullName = _fullNameController.text.trim();
  //   final gender = _genderController.text.trim();
  //   final phoneNumber = _phoneController.text.trim();
  //
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     await _authService.signUpWithPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       username: username,
  //       fullName: fullName,
  //       gender: gender,
  //       onCodeSent: (verificationId) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) =>
  //                 VerificationScreen(
  //                   signUpMethod: SignUpMethod.phoneNumber,
  //                   verificationId: verificationId,
  //                   username: username,
  //                   fullName: fullName,
  //                   gender: gender,
  //                 ),
  //           ),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to send OTP: $e')),
  //     );
  //   }
  // }

  Future<void> _signUpEmail(BuildContext context) async {
    if (!_validateInfo(context)) return;

    final username = _userNameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final gender = _genderController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      setState(() {
        _isLoading = true;
      });
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
        gender: gender,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully')));
        // Navigate to the next page or perform any other desired action
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const VerificationScreen(
              signUpMethod: SignUpMethod.email,
              verificationId: '',
              username: '',
              fullName: '',
              gender: '',
            );
          },
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    String titleText =
        widget.signUpMethod == SignUpMethod.email ? 'Email' : 'Phone Number';
    TextInputType inputType = widget.signUpMethod == SignUpMethod.email
        ? TextInputType.emailAddress
        : TextInputType.phone;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    controller: widget.signUpMethod == SignUpMethod.email
                        ? _emailController
                        : _phoneController,
                    title: titleText,
                    keyboardType: inputType,
                    hintText: widget.signUpMethod == SignUpMethod.email
                        ? "abc@gmail.com"
                        : "08123456789",
                    inputLength:
                        widget.signUpMethod == SignUpMethod.email ? 50 : 14,
                  ),
                  CreateAccountField(
                    controller: _passwordController,
                    title: "Password",
                    keyboardType: TextInputType.text,
                    hintText: "Av3*fs",
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    inputLength: 20,
                  ),
                  CreateAccountField(
                    controller: _confirmPasswordController,
                    title: "Confirm Password",
                    keyboardType: TextInputType.text,
                    hintText: "Av3*fs",
                    obscureText: true,
                    inputLength: 20,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            widget.signUpMethod == SignUpMethod.email
                                ? _signUpEmail(context)
                                : _signUpPhone(context);
                          },
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

  bool _validateInfo(BuildContext context) {
    final username = _userNameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final gender = _genderController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        fullName.isEmpty ||
        gender.isEmpty ||
        // email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return false;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    }
    if (gender != "Male" &&
        gender != "male" &&
        gender != "Female" &&
        gender != "female") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gender can only be male or female')),
      );
      return false;
    }

    return true;
  }
}
