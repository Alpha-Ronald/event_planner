import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';
import '../../../core/textStyles.dart';
import '../../../providers/theme_provider.dart';
import '../../../services/firbase_auth.dart';
import '../widgets/create_account_field.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final TextEditingController _userNameOREmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
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
          children: [
            Text('Sign In'),
            SizedBox(height: 20.h),
            CreateAccountField(
              title: 'Username Or Email',
              hintText: 'dav-06',
              keyboardType: TextInputType.text,
              controller: _userNameOREmailController,
              inputLength: 50,
            ),
            CreateAccountField(
              controller: _passwordController,
              title: "Password",
              keyboardType: TextInputType.text,
              hintText: "Av3*fs",
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              inputLength: 20,
            ),
            SizedBox(height: 20.h),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () async {
                      String input = _userNameOREmailController.text.trim();
                      String password = _passwordController.text.trim();

                      if (input.isNotEmpty && password.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          User? user = await _authService
                              .signInWithUsernameOrEmail(input, password);
                          if (user != null) {
                            // Navigate to the next screen after successful login
                            if (!user.emailVerified) {
                              _showVerificationDialog();
                            } else {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LogInScreen();
                              }));
                            }
                          }
                        } catch (error) {
                          // Show error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        // Handle empty input error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill in both fields.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(15.h),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontWeight: titleStyle.fontWeight,
                          fontSize: titleStyle.fontSize,
                          color: Colors.white),
                    ),
                  ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () {
                // Forgot password action
                _forgotPasswordDialog();
              },
              child: const Text('Forgot Password?'),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // Google sign-in logic here
                  },
                  icon: const Icon(Icons.g_mobiledata),
                ),
                IconButton(
                  onPressed: () {
                    // Facebook sign-in logic here
                  },
                  icon: const Icon(Icons.facebook),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Email not verified"),
          content: const Text(
              "Please verify your email before logging in. Would you like to resend the verification email?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _authService.resendVerificationEmail();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Verification email sent!")),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to send email: $error")),
                  );
                }
              },
              child: const Text("Resend Email"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _forgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Forgot Password"),
          content: TextField(
            decoration: const InputDecoration(hintText: "Enter your email"),
            controller: _userNameOREmailController,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String email = _userNameOREmailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    await _authService.sendPasswordResetEmail(email);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Password reset email sent!")),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to send email: $error")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your email.")),
                  );
                }
              },
              child: const Text("Send"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

//what form of sgn in, username, email, phonenumber. Can i sign in with just one field?
//remember to include other sign in oprtions ,
// and also remember to include forgot password screen to reset password
