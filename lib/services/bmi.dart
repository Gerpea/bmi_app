import 'package:bmi/models/bmi.dart';

num calculateBMI(num weight, num height) {
  return weight / (height * height);
}
