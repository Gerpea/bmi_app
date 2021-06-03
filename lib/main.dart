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
      theme: ThemeData(
          fontFamily: 'Ubuntu',
          backgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            headline1: TextStyle(fontWeight: FontWeight.w500, fontSize: 48),
            headline2: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
            headline4: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
            subtitle1: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                fontFamily: 'Open Sans'),
          ).apply(bodyColor: kTextColor, displayColor: kTextColor)),
      home: BMIScreen(),
    );
  }
}
