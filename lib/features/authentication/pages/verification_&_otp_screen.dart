import 'package:event_planner_app/core/textStyles.dart';
import 'package:event_planner_app/utils/sign_up_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../services/firbase_auth.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({
    super.key,
    required this.signUpMethod,
  });

  final SignUpMethod signUpMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Your Account',
          style: titleStyle,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
                visible: signUpMethod == SignUpMethod.email,
                child: EmailVerification()),
            Visibility(
                visible: signUpMethod == SignUpMethod.phoneNumber,
                child: OtpVerification())
          ],
        ),
      ),
    );
  }
}

class OtpVerification extends StatelessWidget {
  OtpVerification({
    super.key,
  });

  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter the OTP sent to your phone number.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20.h,
        ),
        Pinput(
          length: 6,
          controller: _otpController,
          onCompleted: (pin) {},
        ),
        //   async {
        //     try {
        //       AuthService _authService = AuthService();
        //       final user = await _authService.verifyOtpAndCreateAccount(
        //         verificationId: verificationId,
        //         smsCode: pin,
        //         username: username,
        //         fullName: fullName,
        //         gender: gender,
        //       );
        //
        //       if (user != null) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(content: Text('Account created successfully')),
        //         );
        //         // Navigate to the next page or perform any other desired action
        //       }
        //     } catch (e) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('Failed to verify OTP: $e')),
        //       );
        //     }
        //   },
        // ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Resend OTP'))
      ],
    );
  }
}

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'A verification email has been sent to your email',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        Text('Your account must be verified before Login',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: titleStyle.fontSize,
                color: Colors.red) //TextStyle(fontSize: 20),
            ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Resend Email'))
      ],
    );
  }
}
