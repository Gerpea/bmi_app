import 'package:bmi/components/my_range_slider.dart';
import 'package:bmi/constants.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:color_models/color_models.dart';
import 'dart:math' as math;

// ignore: must_be_immutable
class SliderInput extends StatefulWidget {
  final Color color;
  late Color shadowColor;
  final bool isVertical;

  SliderInput({Key? key, this.color = Colors.orange, this.isVertical = true})
      : super(key: key) {
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
  double _value = 55.0;

  handleChangeValue(double newValue) {
    setState(() {
      _value = newValue;
    });
  }

  static final RangeThumbSelector _customRangeThumbSelector = (
    TextDirection textDirection,
    RangeValues values,
    double tapValue,
    Size thumbSize,
    Size trackSize,
    double dx,
  ) {
    final double touchRadius = math.max(thumbSize.width, 48) / 2;
    final bool inStartTouchTarget =
        (tapValue - values.start).abs() * trackSize.width < touchRadius;
    final bool inEndTouchTarget =
        (tapValue - values.end).abs() * trackSize.width < touchRadius;

    if (inStartTouchTarget && inEndTouchTarget) {
      bool towardsStart;
      bool towardsEnd;
      switch (textDirection) {
        case TextDirection.ltr:
          towardsStart = dx < 0;
          towardsEnd = dx > 0;
          break;
        case TextDirection.rtl:
          towardsStart = dx > 0;
          towardsEnd = dx < 0;
          break;
      }
      if (towardsStart) return null;
      if (towardsEnd) return Thumb.end;
    } else {
      if (tapValue < values.start || inStartTouchTarget) return null;
      if (tapValue > values.end || inEndTouchTarget) return Thumb.end;
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 244,
      height: 244,
      child: RotatedBox(
        quarterTurns: widget.isVertical ? -1 : 0,
        child: Column(
          children: [
            Text(
              _value.toStringAsFixed(2),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: kUnderweightColor),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 27,
                activeTrackColor: kUnderweightColor,
                inactiveTrackColor: kBackgroundColor,
                thumbColor: kBackgroundColor,
                rangeThumbShape: RangeSliderThumb(),
                disabledActiveTrackColor: kBackgroundColor.withAlpha(0x3F),
                thumbSelector: _customRangeThumbSelector,
                rangeTrackShape: RangeSliderTrack(),
                minThumbSeparation: 0,
              ),
              child: MyRangeSlider(
                isVertical: widget.isVertical,
                min: 0,
                max: 100,
                values: RangeValues(30, _value),
                onChanged: (values) => {handleChangeValue(values.end)},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RangeSliderThumb extends RangeSliderThumbShape {
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
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    final height =
        sliderTheme.trackHeight != null ? sliderTheme.trackHeight! : 27;
    if (thumb == Thumb.end) {
      final shadowColor = _getShadowColor(sliderTheme.thumbColor!);

      final circle = Path()
        ..addOval(Rect.fromCircle(center: center, radius: height / 2 - 1));

      final outerShadowPaint = Paint()
        ..color = shadowColor.withAlpha(0xBF)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5);

      final fillPaint = Paint()
        ..color = sliderTheme.thumbColor!
        ..style = PaintingStyle.fill;

      canvas.drawPath(circle, fillPaint);
      canvas.drawPath(circle, outerShadowPaint);
    } else {
      final line = Path()
        ..addRect(Rect.fromLTWH(
            center.dx, center.dy - height / 2 + 1, 1, height - 2));
      final inactiveArea = Path()
        ..addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(0, center.dy - height / 2 + 1, center.dx, height - 2),
          topLeft: Radius.circular(height / 2),
          bottomLeft: Radius.circular(height / 2),
        ));

      final linePaint = Paint()
        ..color = sliderTheme.thumbColor!
        ..style = PaintingStyle.fill;

      final areaPaint = Paint()
        ..color = sliderTheme.disabledActiveTrackColor!
        ..style = PaintingStyle.fill;

      canvas.drawPath(line, linePaint);
      canvas.drawPath(inactiveArea, areaPaint);
    }
  }
}

class RangeSliderTrack extends RangeSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool? isEnabled = false,
    bool? isDiscrete = false,
  }) {
    final double overlayWidth = sliderTheme.overlayShape != null
        ? sliderTheme.overlayShape!
            .getPreferredSize(isEnabled!, isDiscrete!)
            .width
        : 0;
    final double trackHeight =
        sliderTheme.trackHeight != null ? sliderTheme.trackHeight! : 27;
    ;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width;
    final double trackBottom = trackTop + trackHeight;

    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
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

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset startThumbCenter,
      required Offset endThumbCenter,
      bool isEnabled = false,
      bool isDiscrete = false,
      required TextDirection textDirection}) {
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
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    Paint leftTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
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
        Rect.fromLTRB(trackRect.left, trackRect.top + 1, endThumbCenter.dx,
            trackRect.bottom - 1),
        topLeft: Radius.circular(trackRect.height / 2),
        bottomLeft: Radius.circular(trackRect.height / 2),
      ));
    context.canvas.drawPath(leftTrackSegment, leftTrackPaint);

    final spread = 0.3;
    final shadowColor =
        _getShadowColor(sliderTheme.inactiveTrackColor!).withAlpha(0x3F);
    final shadowPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(trackRect.left, trackRect.top + 1, trackRect.right,
            trackRect.bottom - 1),
        Radius.circular(trackRect.height / 2),
      ))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTRB(trackRect.left + spread, trackRect.top + 1 + spread,
            trackRect.right - spread, trackRect.bottom - spread - 1),
        Radius.circular(trackRect.height / 2),
      ))
      ..fillType = PathFillType.evenOdd;

    for (var i = 1; i <= 5; i++) {
      final shadowPaint = Paint()
        ..color = shadowColor.withAlpha(0x3F)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, convertRadiusToSigma((i * spread).toDouble()));
      context.canvas.drawPath(shadowPath, shadowPaint);
    }
  }
}
