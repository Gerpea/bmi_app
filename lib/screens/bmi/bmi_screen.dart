import 'package:bmi/constants.dart';
import 'package:flutter/material.dart';
import 'package:bmi/models/bmi.dart';
import 'package:bmi/components/slider.dart';

class BMIScreen extends StatelessWidget {
  final BMI bmi = BMI(24.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SliderInput(
        color: kBackgroundColor,
      )),
    );
  }
}
