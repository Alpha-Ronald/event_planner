import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

import 'features/authentication/pages/create_account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
      "AIzaSyCpbL9l2qDfELlCY_2LMsgUuqKvT1q70mo",
      appId:
      "1:897035289106:android:4068419aa5d4b5f5e40ecb",
      messagingSenderId: "897035289106",
      projectId:"event-planner-8a49d",
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      //Overlay support to allow display of notifications easily
      builder: (context, child) => OverlaySupport.global(
        child: MaterialApp(debugShowCheckedModeBanner: false,
        title: 'Event Planner',
          theme: ThemeData(
            useMaterial3: true
          ),
          home: const CreateAccountPage(),
        )
      ),


    );
  }
}


//using screenutil to make images responsive
// body: Center(
// child: Image.asset(
// 'assets/images/welcome.png',
// width: 150.w, // Example of using ScreenUtil for image size
// height: 150.h,
// ),


