import 'package:flutter/material.dart';

import 'package:bmi/screens/bmi/bmi_screen.dart';
import 'package:bmi/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI',
      theme: ThemeData.light().copyWith(backgroundColor: kBackgroundColor),
      home: BMIScreen(),
    );
  }
}
