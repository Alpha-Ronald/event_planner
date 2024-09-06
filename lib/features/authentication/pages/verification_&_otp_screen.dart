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
    this.verificationId,
    required this.username,
    required this.fullName,
    required this.gender,
  });

  final SignUpMethod signUpMethod;
  final String? verificationId;
  final String username;
  final String fullName;
  final String gender;

  @override
  Widget build(BuildContext context) {
    if (verificationId == null) {
      return Center(
        child: Text(
          'Verification ID is missing. Please try again.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

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
                child: OtpVerification(
                  verificationId: verificationId!,
                  username: username,
                  fullName: fullName,
                  gender: gender,
                ))
          ],
        ),
      ),
    );
  }
}

class OtpVerification extends StatefulWidget {
  OtpVerification({
    super.key,
    required this.verificationId,
    required this.username,
    required this.fullName,
    required this.gender,
  });

  final String verificationId;
  final String username;
  final String fullName;
  final String gender;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading = false;

  final AuthService _authService = AuthService();

  Future<void> _verifyOtp(BuildContext context) async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final user = await _authService.verifyOTPAndCreateAccount(
        verificationId: widget.verificationId,
        smsCode: otp,
        username: widget.username,
        fullName: widget.fullName,
        gender: widget.gender,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully')),
        );
        // Navigate to home or next page
        // Navigator.pushReplacement(context, MaterialPageRoute(
        //   builder: (context) {
        //     return const HomeScreen(); // or the next screen
        //   },
        // ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => _verifyOtp(context),
                child: const Text('Verify OTP'),
              ),
        ElevatedButton(
          onPressed: () {
            // Handle OTP Resend (Optional)
          },
          child: const Text('Resend OTP'),
        ),
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
