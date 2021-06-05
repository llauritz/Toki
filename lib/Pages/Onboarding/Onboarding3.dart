import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding3 extends StatefulWidget {
  @override
  _Onboarding3State createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  double tagesstunden = 8.0;

  @override
  void initState() {
    tagesstunden = getIt<Data>().tagesstunden;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            """Wie viele Stunden arbeitest du am Tag?""",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: "BandeinsSans"),
          ),
        ),
        /*SizedBox(
          height: 20,
        ),
        Text(
          tagesstunden.toString() + " Stunden",
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: "BandeinsSans",
              color: Colors.white),
        ),*/
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(60.0, 0, 0, 0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: OnboardingSliderThumbRect(
                min: 0,
                max: 12,
                thumbHeight: 40.0,
                thumbWidth: 100.0,
                thumbRadius: 0,
                color: Colors.white,
                textcolor: editColor,
              ),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              inactiveTrackColor: Colors.white.withAlpha(50),
              activeTrackColor: Colors.white.withAlpha(200),
              //valueIndicatorShape: RectangularSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: settingsTitle.copyWith(color: editColor),
            ),
            child: Slider(
              value: tagesstunden,
              onChanged: (newTagesstunden) {
                setState(() {
                  tagesstunden = newTagesstunden;
                });
              },
              onChangeEnd: (newTagesstunden) {
                setState(() {
                  getIt<Data>().updateTagesstunden(newTagesstunden);
                });
              },
              min: 0,
              max: 12,
              divisions: 24,
              //label: "$tagesstunden Stunden",
            ),
          ),
        ),
        SizedBox(height: 40)
      ],
    );
  }
}

class OnboardingSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final thumbWidth;
  final int min;
  final int max;
  final Color color;
  final Color textcolor;

  const OnboardingSliderThumbRect({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.min,
    required this.max,
    required this.thumbWidth,
    required this.color,
    required this.textcolor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(60, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Tween<double> sizeTween = Tween<double>(
      begin: thumbWidth,
      end: thumbHeight,
    );
    final double evaluatedSize = sizeTween.evaluate(activationAnimation);

    final Tween<double> translationTweenY = Tween<double>(
      begin: 0,
      end: -thumbHeight + 5,
    );
    final double evaluatedTranslationY =
        translationTweenY.evaluate(activationAnimation);

    final topRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center.translate(0, evaluatedTranslationY),
          width: thumbWidth,
          height: thumbHeight),
      Radius.circular(100),
    );

    final botRRect = RRect.fromRectAndCorners(
      Rect.fromCenter(
          center: center.translate(0, 0),
          width: thumbHeight * 0.2,
          height: thumbHeight * 0.8),
      topLeft: Radius.circular(0),
      bottomRight: Radius.circular(100),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(100),
    );

    final paint = Paint()
      ..color = color //Thumb Background Color
      ..style = PaintingStyle.fill;

    final Tween<double> opacityTween = Tween<double>(
      begin: 255,
      end: 0,
    );
    final double evaluatedOpacity = opacityTween.evaluate(activationAnimation);

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textcolor,
            height: 1),
        text: '${getValue(value)} Stunden');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter = Offset(center.dx - (tp.width / 2),
        center.dy - (tp.height / 2) + 1.5 + evaluatedTranslationY);

    final Tween<double> elevationTween = Tween<double>(
      begin: 3,
      end: 5,
    );
    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);

    Path rRpath = Path();
    rRpath.addRRect(botRRect);
    rRpath.addRRect(topRRect);
    canvas.drawShadow(rRpath, Colors.black, evaluatedElevation, false);
    canvas.drawRRect(topRRect, paint);
    canvas.drawRRect(botRRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).toString();
  }
}
