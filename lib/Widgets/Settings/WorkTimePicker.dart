import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class WorkTimePicker extends StatefulWidget {
  const WorkTimePicker({Key? key, required this.color, required this.onboarding}) : super(key: key);

  final Color color;
  final bool onboarding;

  @override
  _WorkTimePickerState createState() => _WorkTimePickerState();
}

class _WorkTimePickerState extends State<WorkTimePicker> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Widget _widget = getIt<Data>().individualTimes
        ? ExpandedWorkTImePicker(color: widget.color, onboarding: widget.onboarding)
        : CollapsedWorkTimePicker(color: widget.color, onboarding: widget.onboarding);
    Widget _buttonText = getIt<Data>().individualTimes
        ? Text(
            "Alle Tage gemeinsam einstellen",
            key: ValueKey(0),
            style: openButtonText.copyWith(color: Theme.of(context).colorScheme.onSurface),
          )
        : Text(
            "Jeden Tag individuell einstellen",
            key: ValueKey(1),
            style: openButtonText.copyWith(color: Theme.of(context).colorScheme.onSurface),
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(offset: Offset(0, 8), blurRadius: 8, color: Colors.black.withAlpha(15))],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            if (!widget.onboarding)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Arbeitszeiten",
                  style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18),
                ),
              ),
            widget.onboarding
                ? AnimatedCrossFade(
                    sizeCurve: Curves.ease,
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeInCubic,
                    firstChild: CollapsedWorkTimePicker(color: widget.color, onboarding: widget.onboarding),
                    secondChild: ExpandedWorkTImePicker(color: widget.color, onboarding: widget.onboarding),
                    crossFadeState: getIt<Data>().individualTimes ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 500))
                : AnimatedSize(
                    vsync: this,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 500),
                    child: PageTransitionSwitcher(
                      reverse: !getIt<Data>().individualTimes,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
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
                                child: _buttonText,
                                duration: const Duration(milliseconds: 500),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CollapsedWorkTimePicker extends StatefulWidget {
  const CollapsedWorkTimePicker({Key? key, required this.color, required this.onboarding}) : super(key: key);

  final Color color;
  final bool onboarding;

  @override
  _CollapsedWorkTimePickerState createState() => _CollapsedWorkTimePickerState();
}

class _CollapsedWorkTimePickerState extends State<CollapsedWorkTimePicker> {
  List<bool> _selections = getIt<Data>().wochentage;
  List<int> workingTime = getIt<Data>().workingTime;
  bool divisions = true;

  @override
  void initState() {
    divisions = workingTime[0] / Duration.millisecondsPerHour % 0.5 == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Column(
        children: [
          if (!widget.onboarding)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: WorkdayButtonRow(selections: _selections, color: widget.color),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayShape: SliderComponentShape.noOverlay,
                      trackHeight: 7,
                      trackShape: WorktimeSliderTrackShape(),
                      thumbShape: WorkTimeSliderThumbRect(
                          min: 0,
                          max: workingTime[0] < (12.0 * Duration.millisecondsPerHour) ? 12 : workingTime[0] / Duration.millisecondsPerHour,
                          thumbHeight: 40.0,
                          thumbWidth: 100.0,
                          thumbRadius: 0,
                          color: widget.color,
                          textcolor: Theme.of(context).colorScheme.onPrimary,
                          enabled: workingTime[0] != 0),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: Colors.transparent,
                      inactiveTrackColor: widget.color.withAlpha(50),
                      activeTrackColor: widget.color.withAlpha(200),
                    ),
                    child: Slider(
                      value: workingTime[0] * 1.0,
                      onChangeStart: (_) {
                        divisions = true;
                      },
                      onChanged: (newTagesstunden) {
                        setState(() {
                          workingTime[0] = newTagesstunden.toInt();
                        });
                      },
                      onChangeEnd: (newTagesstunden) {
                        if (newTagesstunden / Duration.millisecondsPerHour % 0.5 != 0) {
                          newTagesstunden = ((newTagesstunden / Duration.millisecondsPerHour * 2).round() / 2) * Duration.millisecondsPerHour;
                        }
                        workingTime[0] = newTagesstunden.toInt();
                        setState(() {
                          getIt<Data>().updateWorkingTime(workingTime);
                        });
                      },
                      min: 0,
                      max: workingTime[0] < (12.0 * Duration.millisecondsPerHour) ? 12.0 * Duration.millisecondsPerHour : workingTime[0] * 1.0,
                      divisions: divisions ? 24 : null,
                      //label: "$tagesstunden Stunden",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_alt_rounded),
                  color: widget.color,
                  onPressed: () async {
                    int hours = workingTime[0] ~/ Duration.millisecondsPerHour;
                    int minutes = (workingTime[0] - hours * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                    TimeOfDay? newTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay(hour: hours, minute: minutes), helpText: "Arbeitszeit auswählen".toUpperCase());
                    if (newTime != null) {
                      workingTime[0] = newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute;
                      getIt<Data>().updateWorkingTime(workingTime);
                      divisions = workingTime[0] / Duration.millisecondsPerHour % 0.5 == 0;
                      setState(() {});
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ExpandedWorkTImePicker extends StatefulWidget {
  const ExpandedWorkTImePicker({required this.color, Key? key, required this.onboarding}) : super(key: key);

  final Color color;
  final bool onboarding;

  @override
  _ExpandedWorkTImePickerState createState() => _ExpandedWorkTImePickerState();
}

class _ExpandedWorkTImePickerState extends State<ExpandedWorkTImePicker> {
  List<bool> _selections = getIt<Data>().wochentage;
  List<int> workingTime = getIt<Data>().workingTime;
  List<int> cachedWorkingTime = getIt<Data>().workingTime;
  List<String> days = ["MO", "DI", "MI", "DO", "FR", "SA", "SO"];
  List<bool> divisions = List.filled(7, true);

  @override
  void initState() {
    divisions = List.generate(workingTime.length, (index) => workingTime[index] / Duration.millisecondsPerHour % 0.5 == 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          if (widget.onboarding)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Text(
                """Wie viele Stunden arbeitest du am Tag?""",
                textAlign: TextAlign.center,
                style: TextStyle(color: grayAccent, fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "BandeinsSans"),
              ),
            ),
          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                TextStyle style = TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 19.0, height: 1, color: _selections[index] ? widget.color : widget.color.withAlpha(50));
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
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: style,
                                  child: Text(
                                    days[index],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: SliderComponentShape.noOverlay,
                            trackShape: WorktimeSliderTrackShape(),
                            trackHeight: 7,
                            thumbShape: WorkTimeSliderThumbRect(
                                min: 0,
                                max: workingTime[index] < (12.0 * Duration.millisecondsPerHour)
                                    ? 12
                                    : workingTime[index] / Duration.millisecondsPerHour,
                                thumbHeight: 35.0,
                                thumbWidth: 100.0,
                                thumbRadius: 0,
                                color: widget.color,
                                textcolor: Theme.of(context).colorScheme.onPrimary,
                                enabled: _selections[index]),
                            activeTickMarkColor: Colors.transparent,
                            inactiveTickMarkColor: Colors.transparent,
                            inactiveTrackColor: widget.color.withAlpha(50),
                            activeTrackColor: widget.color.withAlpha(200),
                          ),
                          child: Slider(
                            value: _selections[index] ? workingTime[index] * 1.0 : 0,
                            onChangeStart: (_) {
                              divisions[index] = true;
                            },
                            onChanged: (newTagesstunden) {
                              _selections[index] = true;
                              getIt<Data>().updateWochentage(_selections);
                              if (newTagesstunden == 0) {
                                _selections[index] = false;
                                getIt<Data>().updateWochentage(_selections);
                              }
                              setState(() {
                                workingTime[index] = newTagesstunden.toInt();
                              });
                            },
                            onChangeEnd: (newTagesstunden) {
                              setState(() {
                                if (newTagesstunden / Duration.millisecondsPerHour % 0.5 != 0) {
                                  newTagesstunden = ((newTagesstunden / Duration.millisecondsPerHour * 2).round() / 2) * Duration.millisecondsPerHour;
                                }
                                workingTime[index] = newTagesstunden.toInt();
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
                            max: workingTime[index] < (12.0 * Duration.millisecondsPerHour)
                                ? 12.0 * Duration.millisecondsPerHour
                                : workingTime[index] * 1.0,
                            divisions: divisions[index] ? 24 : null,
                            //label: "$tagesstunden Stunden",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_alt_rounded),
                        color: widget.color,
                        onPressed: () async {
                          int hours = workingTime[index] ~/ Duration.millisecondsPerHour;
                          int minutes = (workingTime[index] - hours * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                          TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(hour: hours, minute: minutes),
                              helpText: "Arbeitszeit auswählen".toUpperCase());

                          if (newTime != null) {
                            if (newTime.hour + newTime.minute != 0) {
                              _selections[index] = true;
                              getIt<Data>().updateWochentage(_selections);
                            } else {
                              _selections[index] = false;
                              getIt<Data>().updateWochentage(_selections);
                            }
                            workingTime[index] = newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute;
                            getIt<Data>().updateWorkingTime(workingTime);
                            divisions[index] = workingTime[index] / Duration.millisecondsPerHour % 0.5 == 0;
                            setState(() {});
                          }
                        },
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class WorkTimeSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final thumbHeight;
  final thumbWidth;
  final double min;
  final double max;
  final Color color;
  final Color textcolor;
  final bool enabled;

  const WorkTimeSliderThumbRect({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.min,
    required this.max,
    required this.thumbWidth,
    required this.color,
    required this.textcolor,
    required this.enabled,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
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

    final Tween<double> opacityTween = Tween<double>(
      begin: 0,
      end: 255,
    );
    final double evaluatedOpacity = opacityTween.evaluate(activationAnimation);

    final colorTween = Tween<double>(end: 255, begin: enabled ? 255 : 100);
    final int evaluatedColorAlpha = colorTween.evaluate(activationAnimation).toInt();

    final paint = Paint()
      ..color = color.withAlpha(evaluatedColorAlpha) //Thumb Background Color
      ..style = PaintingStyle.fill;
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
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
    canvas.drawShadow(rRpath, neon.withAlpha(50 - (mapRange(evaluatedFactor, 0, 1, 1, 0) * (enabled ? 0 : 30)).toInt()), evaluatedElevation, false);
    canvas.drawRRect(topRRect, whitePaint);
    canvas.drawRRect(topRRect, paint);
    canvas.drawRRect(botRRect, botPaint);
    canvas.drawRRect(handleRect, handlePaint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    //print(value);
    return (min + (max - min) * value).toStringAsFixed(1).replaceAll(".", ",");
  }
}

class WorktimeSliderTrackShape extends SliderTrackShape {
  double trackWidth = 0;
  double thumbWidth = 0;

  @override
  Rect getPreferredRect(
      {required RenderBox parentBox, Offset offset = Offset.zero, required SliderThemeData sliderTheme, bool? isEnabled, bool? isDiscrete}) {
    thumbWidth = sliderTheme.thumbShape!
        .getPreferredSize(
          true,
          true,
        )
        .width;
    double trackHeight = sliderTheme.trackHeight!;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackLeft = offset.dx + thumbWidth / 2;
    trackWidth = parentBox.size.width - thumbWidth;

    return Rect.fromLTWH(
      trackLeft,
      trackTop,
      trackWidth,
      trackHeight,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required Animation<double> enableAnimation,
      required Offset thumbCenter,
      bool? isEnabled,
      bool? isDiscrete,
      required TextDirection textDirection}) {
    // Check for slider track height
    if (sliderTheme.trackHeight == 0) return;
    // Get the rect that we just calculated
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePathPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final activePathSegment = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
            Rect.fromPoints(
              Offset(trackRect.left + thumbCenter.dx, trackRect.top),
              Offset(trackRect.left - thumbWidth / 2, trackRect.bottom),
            ),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10)),
      );

    final Paint inactivePathPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    final inactivePathSegment = Path()
      ..addRRect(RRect.fromRectAndCorners(
          Rect.fromPoints(
            Offset(trackRect.left + thumbCenter.dx, trackRect.top + 1),
            Offset(trackRect.right + thumbWidth / 2, trackRect.bottom - 1),
          ),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10)));

    //context.canvas.drawRect(trackRect, defaultPathPaint);
    context.canvas.drawPath(activePathSegment, activePathPaint);
    context.canvas.drawPath(inactivePathSegment, inactivePathPaint);
  }
}

class WorkdayButtonRow extends StatefulWidget {
  const WorkdayButtonRow({Key? key, required List<bool> selections, required this.color})
      : _selections = selections,
        super(key: key);

  final List<bool> _selections;
  final Color color;

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
          color: widget.color.withAlpha(50),
          selectedColor: widget.color,
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
            getIt<Data>().updateWochentage(widget._selections);
          },
        ),
      );
    });
  }
}
