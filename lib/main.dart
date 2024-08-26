import 'package:event_planner_app/core/colors.dart';
import 'package:event_planner_app/features/authentication/pages/sign_up_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:riverpod/riverpod.dart';
import 'providers/theme_provider.dart';

import 'features/authentication/pages/create_account_screen.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData currentTheme = ref.watch(themeNotifierProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      //Overlay support to allow display of notifications easily
      builder: (context, child) => OverlaySupport.global(
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Planner',
        theme: currentTheme,
        // ThemeData(
        //     useMaterial3: true, scaffoldBackgroundColor: veryLightBlue),
        home: const SignUpOptions(), // CreateAccountPage()//
      )),
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
