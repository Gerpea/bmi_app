import 'dart:math';
import 'dart:ui';

import 'package:bmi/constants.dart';
import 'package:flutter/material.dart';

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
                height: 244,
                width: 244,
              ),
              painter: BMIValue(),
            ),
            Text("Hello"),
          ],
        ),
      ),
    );
  }
}

class BMIValue extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final arcPaint = Paint()
      ..color = kSkinnyColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide - size.shortestSide / (1.618);

    final outerShadowPaint = Paint()
      ..color = Color(0xBF19667D)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5);

    final innerShadowPaint = Paint()
      ..color = kSkinnyColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 10)
      ..shader = RadialGradient(
              colors: [Color(0x7F19667D).withAlpha(0), Color(0x7F19667D)],
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
          0,
          pi);

    canvas.drawPath(arc, arcPaint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.shortestSide / (1.618), outerShadowPaint);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.shortestSide, innerShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
