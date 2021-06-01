import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:color_models/color_models.dart';

import 'package:bmi/components/inner_shadow.dart';

// ignore: must_be_immutable
class SliderInput extends StatefulWidget {
  final Color color;
  Color shadowColor;

  SliderInput({Key key, this.color = Colors.orange}) : super(key: key) {
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    shadowColor = Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
            rgbShadowColor.green, rgbShadowColor.blue)
        .withAlpha(0x3F);
  }

  @override
  _SliderInputState createState() => _SliderInputState();
}

class _SliderInputState extends State<SliderInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 244,
      height: 27,
      child: InnerShadow(
        blur: 5,
        spread: 2,
        color: widget.shadowColor,
        child: Container(
          width: 244,
          height: 27,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50),
            color: widget.color,
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final innerShadowPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 7)
      ..shader = RadialGradient(
        colors: [Colors.orange.withAlpha(0x00), Colors.orange.withAlpha(0x7F)],
        radius: 1,
      ).createShader(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.shortestSide));

    final rect = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(50)));

    canvas.drawPath(rect, innerShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
