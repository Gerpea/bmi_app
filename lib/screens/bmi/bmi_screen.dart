import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bmi/components/circle_progress.dart';
import 'package:bmi/constants.dart';
import 'package:bmi/services/bmi.dart';
import 'package:bmi/models/bmi.dart';
import 'package:bmi/components/slider.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({Key? key}) : super(key: key);

  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double weight = 50;
  double height = 150;
  late BMI bmi = BMI(calculateBMI(weight, height));

  handleWeightChange(double value) {
    setState(() {
      weight = value;
      bmi = BMI(calculateBMI(weight, height));
    });
  }

  handleHeightChange(double value) {
    setState(() {
      height = value;
      bmi = BMI(calculateBMI(weight, height));
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(
          left: kDefaultHorizontalPadding,
          right: kDefaultHorizontalPadding,
          top: kDefaultVerticalPadding + statusBarHeight,
          bottom: kDefaultVerticalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleProgress(
                        max: bmi.value <= 30 ? 30 : bmi.value + 1,
                        value: bmi.value,
                        color: bmi.color,
                      ),
                      Text(
                        bmi.value.toStringAsFixed(1),
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(color: bmi.color),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultVerticalPadding,
                              bottom: kDefaultVerticalPadding / 1.618),
                          child: Text('Skinny',
                              style: Theme.of(context).textTheme.headline2),
                        ),
                        Text(
                            'Your BMI is 24.8 indicationg your weight is on the Skinny category for adults of your height',
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                  ),
                  SliderInput(
                    value: weight,
                    max: weight + 10,
                    min: 10,
                    onChange: handleWeightChange,
                    color: bmi.color,
                  ),
                ],
              ),
            ),
            SliderInput(
              trackHeight: 22,
              value: height,
              max: height + 40,
              min: 40,
              isVertical: true,
              onChange: handleHeightChange,
              color: bmi.color,
            ),
          ],
        ),
      )),
    );
  }
}
