import 'package:event_planner_app/features/authentication/pages/create_account_screen.dart';
import 'package:event_planner_app/features/home_page/pages/home_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';
import '../../../providers/theme_provider.dart';
import '../widgets/sign_up_option_button.dart';

class SignUpOptions extends ConsumerWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode =
        ref.watch(themeNotifierProvider).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignUpButton(
                text: 'Sign-Up with Email',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CreateAccountPage();
                    },
                  ));
                },
                icon: Icon(
                  Icons.email_rounded,
                  color: Colors.blue,
                ),
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              SignUpButton(
                text: 'Sign-Up with Phone number ',
                onPressed: () {},
                icon: Icon(Icons.phone),
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              SignUpButton(
                text: 'Sign-Up with Google',
                onPressed: () {},
                icon: Icon(
                  Icons.g_mobiledata_outlined,
                  color: Colors.redAccent,
                  size: 40.h,
                ),
                color: isDarkMode ? Colors.black : Colors.white,
              ), //replace this with google icon
              SignUpButton(
                text: 'Sign-Up with facebook',
                onPressed: () {},
                icon: Icon(
                  Icons.facebook,
                  color: Colors.blue,
                  size: 30.h,
                ),
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              SizedBox(
                height: 30.h,
              ),
              const Row(
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 1,
                  )),
                  Text('OR'),
                  Expanded(
                      child: Divider(
                    thickness: 1,
                  ))
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SignUpButton(
                  text: 'Log Into my Account',
                  onPressed: () {
                    //Temporary navigation to work on home page
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ));
                  },
                  icon: Icon(
                    Icons.login_outlined,
                    color: Colors.white,
                  ),
                  color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
