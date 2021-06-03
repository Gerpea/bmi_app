import 'package:flutter/material.dart';
import 'package:color_models/color_models.dart';
import 'dart:math';

import 'package:flutter/rendering.dart';

class CircleProgress extends LeafRenderObjectWidget {
  final double max;
  final double value;
  final Color color;

  const CircleProgress(
      {Key? key, this.max = 100, this.value = 0, this.color = Colors.orange})
      : super(key: key);

  @override
  RenderCircleProgress createRenderObject(BuildContext context) {
    return RenderCircleProgress(color: color, max: max, value: value);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCircleProgress renderObject) {
    renderObject
      ..max = max
      ..value = value
      ..color = color;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('max', max));
    properties.add(DoubleProperty('value', value));
    properties.add(ColorProperty('color', color));
  }
}

class RenderCircleProgress extends RenderBox {
  double _max;
  double _value;
  Color _color;

  late Color shadowColor;

  RenderCircleProgress(
      {required double max, required double value, required Color color})
      : assert(max >= value),
        _max = max,
        _value = value,
        _color = color {
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    shadowColor = Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
        rgbShadowColor.green, rgbShadowColor.blue);
  }

  double get max => _max;
  set max(double value) {
    if (_max == value) return;
    _max = value;
    markNeedsPaint();
  }

  double get value => _value;
  set value(double value) {
    if (_value == value) return;
    _value = value;
    markNeedsPaint();
  }

  Color get color => _color;
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    shadowColor = Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
        rgbShadowColor.green, rgbShadowColor.blue);
    markNeedsPaint();
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = min(constraints.maxHeight, constraints.maxWidth);
    final desiredHeight = desiredWidth;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  static const _minDesiredWidth = 40.0;
  @override
  double computeMinIntrinsicWidth(double height) => _minDesiredWidth;
  @override
  double computeMaxIntrinsicWidth(double height) => double.infinity;
  @override
  double computeMinIntrinsicHeight(double width) => _minDesiredWidth;
  @override
  double computeMaxIntrinsicHeight(double width) => double.infinity;

  // @override
  // bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final double outerRadius = size.shortestSide / 2;
    final double innerRadius = outerRadius / 1.618;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final arcPaint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius - innerRadius;

    final outerShadowPaint = Paint()
      ..color = shadowColor.withAlpha(0xBF)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5);

    final innerShadowPaint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 7)
      ..shader = RadialGradient(
          colors: [shadowColor.withAlpha(0x00), shadowColor.withAlpha(0x7F)],
          radius: 0.5,
          stops: [
            0.97,
            1
          ]).createShader(Rect.fromCircle(center: center, radius: outerRadius));

    Path arc = Path()
      ..addArc(
          Rect.fromCircle(
              center: center,
              radius: (innerRadius) + (outerRadius - innerRadius) / 2),
          pi / 2,
          (pi * 2) / _max * _value);

    canvas.drawPath(arc, arcPaint);
    canvas.drawCircle(center, outerRadius, innerShadowPaint);
    canvas.drawCircle(center, innerRadius, outerShadowPaint);

    canvas.restore();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.textDirection = TextDirection.ltr;
    config.label = 'Circle progress';
    config.value = '${(_value)}';
  }
}
