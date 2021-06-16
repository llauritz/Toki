import 'package:Timo/Services/Data.dart';
import 'package:animations/animations.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Services/HiveDB.dart';
import '../Services/Theme.dart';

class OvertimeChangeWidgetOnboarding extends StatefulWidget {
  const OvertimeChangeWidgetOnboarding({
    Key? key,
  }) : super(key: key);

  final Duration duration = const Duration(milliseconds: 700);
  final Duration durationShort = const Duration(milliseconds: 400);
  final Curve curve = Curves.ease;
  final double closedContainerWidth = 0.0;
  final double openContainerWidth = 100;
  final double closedDividerPadding = 0.0;
  final double opendividerPadding = 15;

  @override
  _OvertimeChangeWidgetOnboardingState createState() => _OvertimeChangeWidgetOnboardingState();
}

class _OvertimeChangeWidgetOnboardingState extends State<OvertimeChangeWidgetOnboarding> with TickerProviderStateMixin {
  late AnimationController controller;
  final Color offsetButtonColor = Colors.blueGrey[300]!;

  GlobalKey hoursTextEdit = GlobalKey();
  TextEditingController hoursTextController = TextEditingController();
  int tmpHour = 0;
  bool updateHr = true;
  int hourSnapshotSave = 0;

  GlobalKey minutesTextEdit = GlobalKey();
  TextEditingController minutesTextController = TextEditingController();
  int tmpMinutes = 0;
  bool updateMin = true;
  int minutesSnapshotSave = 0;

  bool isOpen = true;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(
              children: [
                AnimatedContainer(
                    color: Colors.transparent,
                    duration: widget.durationShort,
                    curve: widget.curve,
                    width: isOpen ? 30 : 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.remove_circle_rounded,
                        color: offsetButtonColor,
                      ),
                      onPressed: () {
                        getIt<Data>().addOffset(-Duration.millisecondsPerHour);
                        updateHr = true;
                        updateMin = true;
                      },
                    )),
                StreamBuilder<int>(
                    initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                    stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                    builder: (context, snapshot) {
                      if (hourSnapshotSave != snapshot.data) {
                        hourSnapshotSave = snapshot.data!;
                        updateHr = true;
                      }

                      if (updateHr) {
                        tmpHour = snapshot.data!;
                      }

                      Color _color = tmpHour.isNegative ? gray : editColor;
                      int stunden = (tmpHour / Duration.millisecondsPerHour).truncate();
                      int realStunden = (snapshot.data! / Duration.millisecondsPerHour).truncate();

                      String addMinus = tmpHour.isNegative && stunden == 0 ? "-" : "";

                      if (updateHr) {
                        print("update");
                        String initialString = addMinus + stunden.toString();
                        hoursTextController = TextEditingController.fromValue(
                          TextEditingValue(
                            text: initialString,
                            selection: TextSelection.collapsed(offset: initialString.length),
                          ),
                        );
                        updateHr = false;
                      }

                      Widget _widget = KeyedSubtree(
                          key: stunden == 0 ? ValueKey<Color>(_color) : ValueKey<int>(realStunden),
                          child: AbsorbPointer(
                            absorbing: !isOpen,
                            child: AnimatedFittedTextFieldContainer(
                              growDuration: widget.durationShort,
                              shrinkDuration: widget.durationShort,
                              growCurve: widget.curve,
                              shrinkCurve: widget.curve,
                              child: TextField(
                                enabled: isOpen,
                                controller: hoursTextController,
                                style: overTimeNumbers.copyWith(color: _color),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9, -]')),
                                ],
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.fromLTRB(0, 0, -2.5, 0)),
                                onChanged: (v) {
                                  setState(() {
                                    tmpHour = int.parse(v) * Duration.millisecondsPerHour;
                                    print(hoursTextController.value);
                                  });
                                },
                                onSubmitted: (v) {
                                  int newOffset = int.parse(v) - realStunden;
                                  getIt<Data>().addOffset(newOffset * Duration.millisecondsPerHour);
                                  print("newOffset $newOffset");
                                  updateHr = true;
                                },
                              ),
                            ),
                          ));

                      return AnimatedContainer(
                        duration: widget.duration,
                        curve: widget.curve,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isOpen ? _color.withAlpha(40) : _color.withAlpha(0),
                        ),
                        padding: isOpen ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
                        child: AnimatedSize(
                          vsync: this,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                          child: PageTransitionSwitcher(
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
                            duration: const Duration(milliseconds: 600),
                          ),
                        ),
                      );
                    }),
                AnimatedContainer(
                    color: Colors.transparent,
                    duration: widget.durationShort,
                    curve: widget.curve,
                    width: isOpen ? 30 : 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.add_circle_rounded,
                        color: offsetButtonColor,
                      ),
                      onPressed: () {
                        getIt<Data>().addOffset(Duration.millisecondsPerHour);
                        updateHr = true;
                        updateMin = true;
                      },
                    )),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Stunden",
              style: headline2.copyWith(color: gray),
            )
          ],
        ),
        AnimatedPadding(
            curve: widget.curve,
            duration: widget.duration,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: StreamBuilder<int>(
                initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                builder: (context, snapshot) {
                  Color _color = snapshot.data!.isNegative ? gray : editColor;

                  Widget _widget = KeyedSubtree(
                      key: ValueKey<Color>(_color),
                      child: AnimatedOpacity(
                        duration: widget.durationShort,
                        curve: widget.curve,
                        opacity: isOpen ? 0.5 : 1,
                        child: Text(
                          ":",
                          style: overTimeNumbers.copyWith(color: _color),
                        ),
                      ));

                  return PageTransitionSwitcher(
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
                    duration: const Duration(milliseconds: 600),
                  );
                })),
        Column(
          children: [
            Row(
              children: [
                AnimatedContainer(
                    color: Colors.transparent,
                    duration: widget.durationShort,
                    curve: widget.curve,
                    width: isOpen ? 30 : 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.remove_circle_rounded,
                        color: offsetButtonColor,
                      ),
                      onPressed: () {
                        getIt<Data>().addOffset(-Duration.millisecondsPerMinute);
                        updateHr = true;
                        updateMin = true;
                      },
                    )),
                StreamBuilder<int>(
                    initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                    stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                    builder: (context, snapshot) {
                      if (minutesSnapshotSave != snapshot.data) {
                        minutesSnapshotSave = snapshot.data!;
                        updateMin = true;
                      }

                      if (updateMin) {
                        tmpMinutes = snapshot.data!;
                      }

                      Color _color = tmpMinutes.isNegative ? gray : editColor;
                      int minutes = ((tmpMinutes.abs() / Duration.millisecondsPerMinute) % 60).truncate();
                      int realMinutes = ((snapshot.data! / Duration.millisecondsPerMinute) % 60).truncate();

                      int negativityFactor = snapshot.data!.isNegative ? -1 : 1;

                      if (updateMin) {
                        print("updateMin");
                        String initialString = minutes.toString();
                        print("$initialString");
                        minutesTextController = TextEditingController.fromValue(
                          TextEditingValue(
                            text: initialString.padLeft(2, '0'),
                            selection: TextSelection.collapsed(offset: initialString.length),
                          ),
                        );
                        updateMin = false;
                      }

                      Widget _widget = KeyedSubtree(
                          key: ValueKey<int>(Duration(milliseconds: snapshot.data!).inMinutes),
                          child: AbsorbPointer(
                              absorbing: !isOpen,
                              child: AnimatedDefaultTextStyle(
                                duration: Duration(milliseconds: 300),
                                style: overTimeNumbers.copyWith(color: _color),
                                child: AnimatedFittedTextFieldContainer(
                                  growDuration: widget.durationShort,
                                  shrinkDuration: widget.durationShort,
                                  growCurve: widget.curve,
                                  shrinkCurve: widget.curve,
                                  child: TextField(
                                    enabled: isOpen,
                                    maxLength: 2,
                                    controller: minutesTextController,
                                    style: overTimeNumbers.copyWith(color: _color),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    decoration: const InputDecoration(
                                        counterText: "",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.fromLTRB(0, 0, -2.5, 0)),
                                    onChanged: (v) {
                                      setState(() {
                                        tmpMinutes = int.parse(v) * Duration.millisecondsPerMinute;
                                        print(minutesTextController.value);
                                      });
                                    },
                                    onSubmitted: (v) {
                                      String value = v;
                                      print("realMinutes $realMinutes");
                                      int newOffset;
                                      snapshot.data!.isNegative
                                          ? newOffset = 59 - int.parse(value) - realMinutes.abs()
                                          : newOffset = int.parse(value) - realMinutes.abs();
                                      getIt<Data>().addOffset(newOffset * Duration.millisecondsPerMinute);
                                      print("newOffset $newOffset");
                                      updateMin = true;
                                    },
                                  ),
                                ),
                              )));

                      return AnimatedContainer(
                        duration: widget.duration,
                        curve: widget.curve,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isOpen ? _color.withAlpha(40) : _color.withAlpha(0),
                        ),
                        padding: isOpen ? const EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
                        child: AnimatedSize(
                          vsync: this,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease,
                          child: PageTransitionSwitcher(
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
                            duration: const Duration(milliseconds: 600),
                          ),
                        ),
                      );
                    }),
                AnimatedContainer(
                    duration: widget.durationShort,
                    curve: widget.curve,
                    width: isOpen ? 30 : 0,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        Icons.add_circle_rounded,
                        color: offsetButtonColor,
                      ),
                      onPressed: () {
                        getIt<Data>().addOffset(Duration.millisecondsPerMinute);
                        updateHr = true;
                        updateMin = true;
                      },
                    )),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Minuten",
              style: headline2.copyWith(color: gray),
            )
          ],
        ),
      ],
    );
  }
}
