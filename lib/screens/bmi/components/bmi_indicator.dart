import 'package:flutter/material.dart';
import 'package:bmi/components/circle_progress.dart';
import 'package:bmi/models/bmi.dart';

class BMIIndicator extends StatelessWidget {
  final BMI bmi;

  const BMIIndicator({Key key, this.bmi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          child: Container(
            height: 150,
            width: 150,
          ),
          painter: CircleProgress(
              color: bmi.color,
              value: bmi.value,
              max: bmi.value >= 30 ? bmi.value + 1 : 30),
        ),
        Text(
          bmi.value.toString(),
          style:
              Theme.of(context).textTheme.headline1.copyWith(color: bmi.color),
        ),
      ],
    );
  }
}
