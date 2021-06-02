import 'package:bmi/constants.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:color_models/color_models.dart';
import 'dart:math' as math;

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
  double _value = 10.0;

  handleChangeValue(double newValue) {
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 244,
      height: 27,
      child: Stack(
        children: [
          SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 27,
                trackShape: SliderTrack(),
                activeTrackColor: kUnderweightColor,
                inactiveTrackColor: kBackgroundColor,
                thumbColor: kBackgroundColor,
                thumbShape: SliderThumb(),
              ),
              child: Slider(
                min: 0,
                max: 100,
                value: _value,
                onChanged: handleChangeValue,
              )),
        ],
      ),
    );
  }
}

class SliderThumb extends SliderComponentShape {
  Color _getShadowColor(Color color) {
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    return Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
        rgbShadowColor.green, rgbShadowColor.blue);
  }

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(27, 27);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final shadowColor = _getShadowColor(sliderTheme.thumbColor);

    final circle = Path()
      ..addOval(Rect.fromCircle(
          center: center, radius: sliderTheme.trackHeight / 2 + 1));

    final outerShadowPaint = Paint()
      ..color = shadowColor.withAlpha(0xBF)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5);

    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(circle, fillPaint);
    canvas.drawPath(circle, outerShadowPaint);
  }
}

class SliderTrack extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData sliderTheme,
    bool isEnabled,
    bool isDiscrete,
  }) {
    final double thumbWidth =
        sliderTheme.thumbShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth =
        sliderTheme.overlayShape.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft =
        offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    Animation<double> enableAnimation,
    TextDirection textDirection,
    Offset thumbCenter,
    bool isDiscrete,
    bool isEnabled,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Path leftTrackSegment = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTRB(
            trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom),
        topLeft: Radius.circular(trackRect.height / 2),
        bottomLeft: Radius.circular(trackRect.height / 2),
      ));
    context.canvas.drawPath(leftTrackSegment, leftTrackPaint);

    final Path rightTrackSegment = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTRB(
            thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom),
        topRight: Radius.circular(trackRect.height / 2),
        bottomRight: Radius.circular(trackRect.height / 2),
      ));
    context.canvas.drawPath(rightTrackSegment, rightTrackPaint);

    final spread = 0.3;
    final shadowColor =
        _getShadowColor(sliderTheme.inactiveTrackColor).withAlpha(0x3F);
    final shadowPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(
            trackRect.left, trackRect.top, trackRect.right, trackRect.bottom),
        Radius.circular(trackRect.height / 2),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(trackRect.left + spread, trackRect.top + spread,
            trackRect.right - spread, trackRect.bottom - spread),
        Radius.circular(trackRect.height / 2),
      ))
      ..fillType = PathFillType.evenOdd;

    for (var i = 1; i <= 10; i++) {
      final shadowPaint = Paint()
        ..color = shadowColor.withAlpha(0x3F)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.outer, convertRadiusToSigma((i * spread).toDouble()));
      context.canvas.drawPath(shadowPath, shadowPaint);
    }
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  Color _getShadowColor(Color color) {
    final RgbColor rgbShadowColor =
        RgbColor(color.red, color.green, color.blue, color.alpha)
            .toHsbColor()
            .copyWith(brightness: 50)
            .toRgbColor();
    return Color.fromARGB(rgbShadowColor.alpha, rgbShadowColor.red,
        rgbShadowColor.green, rgbShadowColor.blue);
  }
}
