import 'package:event_planner_app/core/textStyles.dart';
import 'package:event_planner_app/utils/sign_up_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key, required this.signUpMethod});

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
  const OtpVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter the OTP sent to your phone number.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20.h,
        ),
        Pinput(
          length: 6,
          onCompleted: (pin) {},
        ),
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
          'A verification email has been sent to your email.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Resend Email'))
      ],
    );
  }
}
