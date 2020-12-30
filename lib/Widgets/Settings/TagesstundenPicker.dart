import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class TagesstundenPicker extends StatefulWidget {
  const TagesstundenPicker({
    @required
    this.isDay,
    Key key,
  }) : super(key: key);

  final bool isDay;

  @override
  _TagesstundenPickerState createState() => _TagesstundenPickerState();
}

class _TagesstundenPickerState extends State<TagesstundenPicker> {

  double _tagesstunden;

  @override
  void initState() {
    // TODO: implement initState
    _tagesstunden = getIt<Data>().tagesstunden;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.isDay
                ? neonTranslucent
                : neon.withAlpha(100)),
            child: const Center(
              child: Icon(Icons.schedule,color: neonAccent,size: 26.0,),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: neon,
                      width: 2.5
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tagesstunden", style: widget.isDay
                        ? settingsTitle
                        : settingsTitle.copyWith(color: Colors.white)),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbShape: CustomSliderThumbRect(
                            min: 0,max: 12,
                            thumbHeight: 32.0,
                            thumbWidth: 45.0,
                            thumbRadius: 10,
                            color: neon,
                            textcolor: widget.isDay ? Colors.white : darkBackground,
                          ),
                          activeTickMarkColor: neonAccent,
                          inactiveTickMarkColor: neonAccent.withAlpha(100),
                          inactiveTrackColor: neon.withAlpha(10),
                          activeTrackColor: neon.withAlpha(20),
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: neon,
                          valueIndicatorTextStyle: widget.isDay
                              ? settingsTitle.copyWith(color: Colors.white)
                              : settingsTitle.copyWith(color: darkBackground)
                        ),
                        child: Slider.adaptive(
                          label: "$_tagesstunden Stunden",
                          value: _tagesstunden,
                          onChanged: (newTagesstunden) {
                            setState(() => _tagesstunden = newTagesstunden);
                          },
                          onChangeEnd: (newTagesstunden) {
                            setState(() {
                              getIt<Data>().updateTagesstunden(newTagesstunden);
                            });
                          },
                          min: 0,
                          max: 12,
                          divisions: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final thumbWidth;
  final int min;
  final int max;
  final Color color;
  final Color textcolor;

  const CustomSliderThumbRect({
    this.thumbRadius,
    this.thumbHeight,
    this.min,
    this.max,
    this.thumbWidth,
    this.color,
    this.textcolor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        TextPainter labelPainter,
        RenderBox parentBox,
        SliderThemeData sliderTheme,
        TextDirection textDirection,
        double value,
        double textScaleFactor,
        Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbWidth, height: thumbHeight),
      Radius.circular(thumbRadius * .4),
    );

    final paint = Paint()
      ..color = color //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: textcolor,
            height: 1),
        text: '${getValue(value)} h');
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
    Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2)+1.5);

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min+(max-min)*value).toString();
  }
}