import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class WorkTimePicker extends StatefulWidget {
  const WorkTimePicker({Key? key}) : super(key: key);

  @override
  _WorkTimePickerState createState() => _WorkTimePickerState();
}

class _WorkTimePickerState extends State<WorkTimePicker> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget _widget = getIt<Data>().individualTimes ? CollapsedWorkTimePicker() : ExpandedWorkTImePicker();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Arbeitszeiten",
                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
              ),
              AnimatedSize(
                vsync: this,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500),
                child: PageTransitionSwitcher(
                  reverse: getIt<Data>().individualTimes,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return SharedAxisTransition(
                      child: child,
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.scaled,
                      fillColor: Colors.transparent,
                    );
                  },
                  child: _widget,
                  duration: const Duration(milliseconds: 500),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                      onPressed: () async {
                        getIt<Data>().toggleIndividualTimes();
                        setState(() {});
                      },
                      shape: const StadiumBorder(),
                      color: grayTranslucent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 3),
                            Text(
                              "Jeden Tag individuell einstellen",
                              style: openButtonText.copyWith(color: grayAccent),
                            ),
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSliderTrack extends SliderTrackShape {
  const CustomSliderTrack({required this.thumbWidth});

  final double thumbWidth;

  @override
  Rect getPreferredRect({RenderBox? parentBox, Offset offset = Offset.zero, SliderThemeData? sliderTheme, bool? isEnabled, bool? isDiscrete}) {
    final double trackLeft;
    final double trackWidth;

    // TODO: implement getPreferredRect
    return Rect.fromLTWH(0, 0, 200, 5);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {RenderBox? parentBox,
      SliderThemeData? sliderTheme,
      required Animation<double> enableAnimation,
      Offset? thumbCenter,
      bool? isEnabled,
      bool? isDiscrete,
      TextDirection? textDirection}) {
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Paint defaultPathPaint = Paint()
      ..color = sliderTheme!.activeTrackColor!
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(RRect.fromRectAndRadius(trackRect, Radius.circular(10)), defaultPathPaint);
  }
}

class CollapsedWorkTimePicker extends StatefulWidget {
  const CollapsedWorkTimePicker({Key? key}) : super(key: key);

  @override
  _CollapsedWorkTimePickerState createState() => _CollapsedWorkTimePickerState();
}

class _CollapsedWorkTimePickerState extends State<CollapsedWorkTimePicker> {
  List<bool> _selections = getIt<Data>().wochentage;
  List<int> workingTime = getIt<Data>().workingTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: WorkdayButtonRow(selections: _selections),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    overlayShape: SliderComponentShape.noOverlay,
                    //trackShape: CustomSliderTrack(thumbWidth: 100),
                    thumbShape: WorkTimeSliderThumbRect(
                      min: 0,
                      max: workingTime[0] < (12.0 * Duration.millisecondsPerHour) ? 12 : workingTime[0] ~/ Duration.millisecondsPerHour,
                      thumbHeight: 40.0,
                      thumbWidth: 100.0,
                      thumbRadius: 0,
                      color: neon,
                      textcolor: Colors.white,
                    ),
                    activeTickMarkColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.transparent,
                    inactiveTrackColor: neon.withAlpha(50),
                    activeTrackColor: neon.withAlpha(200),
                  ),
                  child: Slider(
                    value: workingTime[0] * 1.0,
                    onChanged: (newTagesstunden) {
                      setState(() {
                        workingTime[0] = newTagesstunden.toInt();
                      });
                    },
                    onChangeEnd: (newTagesstunden) {
                      setState(() {
                        getIt<Data>().updateWorkingTime(workingTime);
                      });
                    },
                    min: 0,
                    max: workingTime[0] < (12.0 * Duration.millisecondsPerHour) ? 12.0 * Duration.millisecondsPerHour : workingTime[0] * 1.0,
                    divisions: 24,
                    //label: "$tagesstunden Stunden",
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_alt_rounded),
                color: neon,
                onPressed: () async {
                  int hours = workingTime[0] ~/ Duration.millisecondsPerHour;
                  int minutes = (workingTime[0] - hours * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                  TimeOfDay? newTime = await showTimePicker(context: context, initialTime: TimeOfDay(hour: hours, minute: minutes));
                  if (newTime != null) {
                    workingTime[0] = newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute;
                    getIt<Data>().updateWorkingTime(workingTime);
                    setState(() {});
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

class ExpandedWorkTImePicker extends StatefulWidget {
  const ExpandedWorkTImePicker({
    Key? key,
  }) : super(key: key);

  @override
  _ExpandedWorkTImePickerState createState() => _ExpandedWorkTImePickerState();
}

class _ExpandedWorkTImePickerState extends State<ExpandedWorkTImePicker> {
  List<bool> _selections = getIt<Data>().wochentage;
  List<int> workingTime = getIt<Data>().workingTime;
  List<int> cachedWorkingTime = getIt<Data>().workingTime;
  List<String> days = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            TextStyle style =
                TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0, height: 1, color: _selections[index] ? neon : neon.withAlpha(100));
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      splashColor: Colors.transparent,
                      splashFactory: InkRipple.splashFactory,
                      onTap: () {
                        setState(() {
                          _selections[index] = !_selections[index];
                        });
                        getIt<Data>().updateWochentage(_selections);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 30,
                          width: 40,
                          child: Text(
                            days[index],
                            style: style,
                          ),
                        ),
                      )),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbShape: WorkTimeSliderThumbRect(
                          min: 0,
                          max: 12,
                          thumbHeight: 35.0,
                          thumbWidth: 100.0,
                          thumbRadius: 0,
                          color: neon,
                          textcolor: Colors.white,
                        ),
                        activeTickMarkColor: Colors.transparent,
                        inactiveTickMarkColor: Colors.transparent,
                        inactiveTrackColor: neon.withAlpha(50),
                        activeTrackColor: neon.withAlpha(200),
                      ),
                      child: Slider(
                        value: _selections[index] ? workingTime[index] * 1.0 : 0,
                        onChanged: (newTagesstunden) {
                          _selections[index] = true;
                          getIt<Data>().updateWochentage(_selections);
                          setState(() {
                            workingTime[index] = newTagesstunden.toInt();
                          });
                        },
                        onChangeEnd: (newTagesstunden) {
                          setState(() {
                            if (newTagesstunden == 0) {
                              workingTime[index] = cachedWorkingTime[index];
                              _selections[index] = false;
                              getIt<Data>().updateWochentage(_selections);
                            } else {
                              cachedWorkingTime[index] = newTagesstunden.toInt();
                              getIt<Data>().updateWorkingTime(workingTime);
                            }
                          });
                        },
                        min: 0,
                        max: 12.0 * Duration.millisecondsPerHour,
                        divisions: 24,
                        //label: "$tagesstunden Stunden",
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class WorkTimeSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final thumbWidth;
  final int min;
  final int max;
  final Color color;
  final Color textcolor;

  const WorkTimeSliderThumbRect({
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

    final Tween<double> factor = Tween<double>(begin: 0, end: 1);
    final double evaluatedFactor = factor.evaluate(CurvedAnimation(parent: activationAnimation, curve: Curves.ease));

    final Tween<double> sizeTween = Tween<double>(
      begin: thumbWidth,
      end: thumbHeight,
    );
    final double evaluatedSize = sizeTween.evaluate(activationAnimation);

    final Tween<double> translationTweenY = Tween<double>(
      begin: 0,
      end: -thumbHeight + 5,
    );
    final double evaluatedTranslationY = translationTweenY.evaluate(CurvedAnimation(parent: activationAnimation, curve: Curves.ease));

    // Value = 0 -> +width/2
    // Value = 1 -> -width/2
    final double evaluatedTranslationX = mapRange(value, 0, 1, thumbWidth / 2, -thumbWidth / 2);

    final topRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, evaluatedTranslationY / 2), width: thumbWidth, height: thumbHeight * (1 + evaluatedFactor)),
      Radius.circular(thumbHeight / 2),
    );

    final botRRect = RRect.fromRectAndCorners(
      Rect.fromCenter(center: center.translate(0, 0), width: thumbHeight * 0.3, height: thumbHeight * 0.3),
      topLeft: Radius.circular(100),
      bottomRight: Radius.circular(100),
      topRight: Radius.circular(100),
      bottomLeft: Radius.circular(100),
    );

    final handleRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center.translate(0, 0), width: (thumbWidth - thumbHeight) * evaluatedFactor, height: 5),
      Radius.circular(100),
    );

    final paint = Paint()
      ..color = color //Thumb Background Color
      ..style = PaintingStyle.fill;

    final Tween<double> opacityTween = Tween<double>(
      begin: 0,
      end: 255,
    );
    final double evaluatedOpacity = opacityTween.evaluate(activationAnimation);

    final botPaint = Paint()
      ..color = color.withAlpha(evaluatedOpacity.toInt())
      ..style = PaintingStyle.fill;

    final handlePaint = Paint()
      ..color = Colors.white.withAlpha((evaluatedOpacity * 0.3).toInt())
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
        style: new TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textcolor, height: 1), text: '${getValue(value)} Stunden');
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter = Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2) + 1.5 + evaluatedTranslationY - (5 * evaluatedFactor));

    final Tween<double> elevationTween = Tween<double>(
      begin: 5,
      end: 10,
    );
    final double evaluatedElevation = elevationTween.evaluate(CurvedAnimation(parent: activationAnimation, curve: Curves.ease));

    Path rRpath = Path();
    rRpath.addRRect(botRRect);
    rRpath.addRRect(topRRect);
    canvas.drawShadow(rRpath, neon.withAlpha(50), evaluatedElevation, false);
    canvas.drawRRect(topRRect, paint);
    canvas.drawRRect(botRRect, botPaint);
    canvas.drawRRect(handleRect, handlePaint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).toStringAsFixed(1).replaceAll(".", ",");
  }
}

// class WorktimeSliderTrackShape extends SliderTrackShape{
//   @override
//   Rect getPreferredRect({required RenderBox parentBox, Offset offset = Offset.zero, required SliderThemeData sliderTheme, bool isEnabled, bool isDiscrete}) {
//     // TODO: implement getPreferredRect
//     throw UnimplementedError();
//   }

//   @override
//   void paint(PaintingContext context, Offset offset, {required RenderBox parentBox, required SliderThemeData sliderTheme, required Animation<double> enableAnimation, required Offset thumbCenter, bool isEnabled, bool isDiscrete, required TextDirection textDirection}) {
//     // TODO: implement paint
//   }

// }

class WorkdayButtonRow extends StatefulWidget {
  const WorkdayButtonRow({
    Key? key,
    required List<bool> selections,
  })  : _selections = selections,
        super(key: key);

  final List<bool> _selections;

  @override
  _WorkdayButtonRowState createState() => _WorkdayButtonRowState();
}

class _WorkdayButtonRowState extends State<WorkdayButtonRow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: ToggleButtons(
          constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity, minWidth: constraints.maxWidth / 7),
          borderColor: Colors.white.withAlpha(100),
          color: neon.withAlpha(100),
          selectedColor: neon,
          fillColor: Colors.transparent,
          selectedBorderColor: Colors.white,
          splashColor: Colors.transparent,
          renderBorder: false,
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0, height: 1),
          disabledColor: Colors.white,
          children: <Widget>[
            Text("MO"),
            Text("DI"),
            Text("MI"),
            Text("DO"),
            Text("FR"),
            Text("SA"),
            Text("SO"),
          ],
          isSelected: widget._selections,
          onPressed: (int index) {
            setState(() {
              widget._selections[index] = !widget._selections[index];
            });
            print("dayrow speichern -- Welcome_Screen_4");
            getIt<Data>().updateWochentage(widget._selections);
          },
        ),
      );
    });
  }
}

class WorkdayButtonColumn extends StatefulWidget {
  const WorkdayButtonColumn({
    Key? key,
    required List<bool> selections,
  })  : _selections = selections,
        super(key: key);

  final List<bool> _selections;

  @override
  _WorkdayButtonColumnState createState() => _WorkdayButtonColumnState();
}

class _WorkdayButtonColumnState extends State<WorkdayButtonColumn> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FittedBox(
        fit: BoxFit.fitWidth,
        child: ToggleButtons(
          direction: Axis.vertical,
          constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity, minWidth: constraints.maxWidth / 7),
          borderColor: Colors.white.withAlpha(100),
          color: neon.withAlpha(100),
          selectedColor: neon,
          fillColor: Colors.transparent,
          selectedBorderColor: Colors.white,
          splashColor: Colors.transparent,
          renderBorder: false,
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.0, height: 1),
          disabledColor: Colors.white,
          children: <Widget>[
            Align(alignment: Alignment.centerLeft, child: Text("MO")),
            Align(alignment: Alignment.centerLeft, child: Text("DI")),
            Align(alignment: Alignment.centerLeft, child: Text("MI")),
            Align(alignment: Alignment.centerLeft, child: Text("DO")),
            Align(alignment: Alignment.centerLeft, child: Text("FR")),
            Align(alignment: Alignment.centerLeft, child: Text("SA")),
            Align(alignment: Alignment.centerLeft, child: Text("SO")),
          ],
          isSelected: widget._selections,
          onPressed: (int index) {
            setState(() {
              widget._selections[index] = !widget._selections[index];
            });
            print("dayrow speichern -- Welcome_Screen_4");
            getIt<Data>().updateWochentage(widget._selections);
          },
        ),
      );
    });
  }
}
