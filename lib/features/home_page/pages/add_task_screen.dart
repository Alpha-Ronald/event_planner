import 'package:event_planner_app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Event',
                style: headingStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      //leading: Icon(Icons.arrow_back),
      elevation: 0,
      backgroundColor: veryLightBlue,
      actions: [
        const CircleAvatar(
          backgroundImage: AssetImage('images/my_image.jpg'),
        ),
        SizedBox(
          width: 20.w,
        )
      ],
    );
  }
}
