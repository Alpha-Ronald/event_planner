import 'package:event_planner_app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.light_mode),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [CircleAvatar(
          backgroundImage: AssetImage('images/my_image.jpg'),
        ),
        SizedBox(width: 20.w,)],
      ),
      body: Column(
        children: [Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle,),
                Text("Today", style: headingStyle,)

              ],
              ),

            ],
          ),
        )],

      ),
    );
  }
}