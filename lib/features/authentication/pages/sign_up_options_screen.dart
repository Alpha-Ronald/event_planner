import 'package:event_planner_app/features/authentication/pages/create_account_screen.dart';
import 'package:event_planner_app/features/home_page/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/sign_up_option_container.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.email_rounded),
                color: Colors.blue,
              ),
              SignUpButton(
                  text: 'Sign-Up with Phone number ',
                  onPressed: () {},
                  icon: Icon(Icons.phone),
                  color: Colors.blue),
              SignUpButton(
                  text: 'Sign-Up with Google',
                  onPressed: () {},
                  icon: Icon(Icons.incomplete_circle),
                  color: Colors.blue), //replace this with google icon
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
                height: 10.h,
              ),
              SignUpButton(
                  text: 'Log Into my Account',
                  onPressed: () {//Temporary navigation to work on home page
                    Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ));},
                  icon: Icon(Icons.login_outlined),
                  color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }
}
