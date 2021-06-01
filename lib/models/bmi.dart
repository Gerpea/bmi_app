import 'package:flutter/material.dart';
import 'package:bmi/constants.dart';

enum BMIType {
  Underweight,
  Healthy,
  Overweight,
  Obese,
}

class BMI {
  final num value;
  final Color color;

  factory BMI(value) {
    return BMI.withType(value, _getType(value));
  }

  BMI.withType(this.value, _type) : color = _getColor(_type);
}

BMIType _getType(num value) {
  if (value < 18.5)
    return BMIType.Underweight;
  else if (value <= 24.9)
    return BMIType.Healthy;
  else if (value <= 29.9)
    return BMIType.Overweight;
  else
    return BMIType.Obese;
}

// ignore: missing_return
Color _getColor(BMIType type) {
  switch (type) {
    case BMIType.Underweight:
      return kUnderweightColor;
    case BMIType.Healthy:
      return kHealthyColor;
    case BMIType.Overweight:
      return kOverweightColor;
    case BMIType.Obese:
      return kObesseColor;
  }
}
