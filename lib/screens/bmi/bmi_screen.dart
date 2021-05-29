import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:color_models/color_models.dart';

import 'package:bmi/constants.dart';

class BMIScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              child: Container(
                height: 150,
                width: 150,
              ),
              painter: CircleProgress(color: kNormalColor),
            ),
            Text(
              "24.8",
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: kSkinnyColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleProgress extends CustomPainter {
  final num max;
  final num value;
  final Color color;
  Color shadowColor;

  CircleProgress({this.max = 100, this.value = 10, this.color = Colors.orange})
      : assert(max >= value) {
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    shadowColor = Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
        rgbShadowColor.green, rgbShadowColor.blue);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide - size.shortestSide / (1.618);

    final outerShadowPaint = Paint()
      ..color = shadowColor.withAlpha(0xBF)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5);

    final innerShadowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 7)
      ..shader =
          RadialGradient(
                  colors: [
                    shadowColor.withAlpha(0x00),
                    shadowColor.withAlpha(0x7F)
                  ],
                  radius: 0.5,
                  stops: [0.97, 1])
              .createShader(Rect.fromCircle(
                  center: Offset(size.width / 2, size.height / 2),
                  radius: size.shortestSide));

    Path arc = Path()
      ..addArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2),
              radius: (size.shortestSide + size.shortestSide / (1.618)) / 2),
          pi / 2,
          (pi * 2) / max * value);

    canvas.drawPath(arc, arcPaint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.shortestSide, innerShadowPaint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.shortestSide / (1.618), outerShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/*
if (rgbColor.isBlack) HsbColor(0, 0, 0, rgbColor.alpha);
    if (rgbColor.isWhite) HsbColor(0, 0, 100, rgbColor.alpha);
    if (rgbColor.isMonochromatic) {
      return HsbColor(0, 0, rgbColor.red / 255 * 100, rgbColor.alpha);
    }

    final rgb = rgbColor.toFactoredList();
    final max = rgb.reduce(math.max);
    final min = rgb.reduce(math.min);
    final difference = max - min;
    final saturation = (max == 0.0) ? 0.0 : difference / max;
    final alpha = rgbColor.alpha / 255;

    return HsbColor.extrapolate(
        <double>[getHue(rgbColor), saturation, max, alpha]);
*/