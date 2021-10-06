import 'package:Toki/Services/Data.dart';
import 'package:Toki/Widgets/TimerTextWidget.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/HiveDB.dart';
import '../Services/Theme.dart';

class OvertimeChangeWidgetNoInput extends StatefulWidget {
  const OvertimeChangeWidgetNoInput({
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
  _OvertimeChangeWidgetNoInputState createState() => _OvertimeChangeWidgetNoInputState();
}

class _OvertimeChangeWidgetNoInputState extends State<OvertimeChangeWidgetNoInput> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animationFade;
  final Color offsetButtonColor = Colors.blueGrey[300]!;

  bool isOpen = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    animationFade = Tween<double>(begin: 0, end: 1).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: isOpen ? EdgeInsets.only(top: 10) : EdgeInsets.zero,
      duration: widget.durationShort,
      curve: widget.curve,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: PageTransitionSwitcher(
              reverse: isOpen,
              transitionBuilder: (
                Widget child,
                Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  child: child,
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  fillColor: Colors.transparent,
                );
              },
              child: isOpen
                  ? Container(
                      width: 75,
                      height: 75,
                    )
                  : Tooltip(
                      message: "Zeit bearbeiten",
                      verticalOffset: 30,
                      textStyle: TextStyle(color: gray),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3))]),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              print("pressed");
                              isOpen = !isOpen;
                              !isOpen ? controller.reverse() : controller.forward();
                            });
                          },
                          splashColor: neon.withAlpha(80),
                          highlightColor: neonTranslucent.withAlpha(150),
                          shape: StadiumBorder(),
                          height: 75,
                          minWidth: 75,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: neonTranslucent, borderRadius: BorderRadius.circular(1000)),
                                child: Icon(
                                  Icons.edit,
                                  color: neonAccent,
                                  size: 20,
                                )),
                          ),
                        ),
                      ),
                    ),
              duration: const Duration(milliseconds: 600),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedPadding(
                  duration: widget.durationShort,
                  curve: widget.curve,
                  padding: isOpen ? EdgeInsets.only(top: 30) : EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                          color: Colors.transparent,
                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen ? 30 : 0,
                          child: FadeTransition(
                              opacity: animationFade,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.remove_circle_rounded,
                                  color: offsetButtonColor,
                                ),
                                onPressed: () {
                                  getIt<Data>().addOffset(-Duration.millisecondsPerHour);
                                },
                              ))),
                      StreamBuilder<int>(
                          stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                          builder: (context, snapshot) {
                            Color _color = snapshot.data!.isNegative ? gray : neon;
                            int stunden = (snapshot.data! / Duration.millisecondsPerHour).truncate();

                            String addMinus = snapshot.data!.isNegative && stunden == 0 ? "-" : "";

                            Widget _widget = KeyedSubtree(
                                key: stunden == 0 ? ValueKey<Color>(_color) : ValueKey<int>(stunden),
                                child: Text(
                                  addMinus + stunden.toString(),
                                  style: overTimeNumbers.copyWith(color: _color),
                                ));

                            return AnimatedContainer(
                              duration: widget.duration,
                              curve: widget.curve,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: isOpen ? _color.withAlpha(40) : _color.withAlpha(0),
                              ),
                              padding: isOpen ? EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
                              child: AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 400),
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
                          child: FadeTransition(
                              opacity: animationFade,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.add_circle_rounded,
                                  color: offsetButtonColor,
                                ),
                                onPressed: () {
                                  getIt<Data>().addOffset(Duration.millisecondsPerHour);
                                },
                              ))),
                      AnimatedPadding(
                          curve: widget.curve,
                          duration: widget.duration,
                          padding: EdgeInsets.symmetric(horizontal: isOpen ? widget.opendividerPadding : widget.closedDividerPadding),
                          child: StreamBuilder<int>(
                              initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                              stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                              builder: (context, snapshot) {
                                Color _color = snapshot.data!.isNegative ? gray : neon;

                                Widget _widget = KeyedSubtree(
                                    key: ValueKey<Color>(_color),
                                    child: AnimatedOpacity(
                                      duration: widget.durationShort,
                                      curve: widget.curve,
                                      opacity: isOpen ? 0.2 : 1,
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
                      AnimatedContainer(
                          color: Colors.transparent,
                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen ? 30 : 0,
                          child: FadeTransition(
                              opacity: animationFade,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.remove_circle_rounded,
                                  color: offsetButtonColor,
                                ),
                                onPressed: () {
                                  getIt<Data>().addOffset(-Duration.millisecondsPerMinute);
                                },
                              ))),
                      StreamBuilder<int>(
                          stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                          builder: (context, snapshot) {
                            Color _color = snapshot.data!.isNegative ? gray : neon;
                            int minuten = ((snapshot.data!.abs() / Duration.millisecondsPerMinute) % 60).truncate();

                            Widget _minuten = KeyedSubtree(
                                key: ValueKey<int>(minuten),
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 300),
                                  style: overTimeNumbers.copyWith(color: _color),
                                  child: DoubleDigit(
                                    i: minuten,
                                    style: overTimeNumbers,
                                  ),
                                ));

                            return AnimatedContainer(
                              duration: widget.duration,
                              curve: widget.curve,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: isOpen ? _color.withAlpha(40) : _color.withAlpha(0),
                              ),
                              padding: isOpen ? EdgeInsets.symmetric(horizontal: 4, vertical: 2) : EdgeInsets.zero,
                              child: AnimatedSize(
                                vsync: this,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease,
                                child: Column(
                                  children: [
                                    PageTransitionSwitcher(
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
                                      child: _minuten,
                                      duration: const Duration(milliseconds: 600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      AnimatedContainer(
                          duration: widget.durationShort,
                          curve: widget.curve,
                          width: isOpen ? 30 : 0,
                          child: FadeTransition(
                              opacity: animationFade,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  Icons.add_circle_rounded,
                                  color: offsetButtonColor,
                                ),
                                onPressed: () {
                                  getIt<Data>().addOffset(Duration.millisecondsPerMinute);
                                },
                              ))),
                    ],
                  ),
                ),
                AnimatedPadding(
                  duration: widget.duration,
                  curve: widget.curve,
                  padding: isOpen ? EdgeInsets.symmetric(vertical: 20) : EdgeInsets.zero,
                  child: AnimatedContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    height: isOpen ? 40 : 30,
                    child: PageTransitionSwitcher(
                      reverse: !isOpen,
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
                      child: KeyedSubtree(
                        key: ValueKey<bool>(isOpen),
                        child: isOpen
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                      color: grayTranslucent,
                                      shape: StadiumBorder(),
                                      onPressed: () {
                                        setState(() {
                                          print("pressed");
                                          getIt<Data>().setOffset(0);
                                        });
                                      },
                                      child: Center(
                                          child: Row(
                                        children: [
                                          Icon(
                                            Icons.replay_rounded,
                                            color: gray,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Zurücksetzen",
                                            style: openButtonText.copyWith(color: gray, fontSize: 14),
                                          ),
                                        ],
                                      ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FlatButton(
                                      highlightColor: neon.withAlpha(80),
                                      splashColor: neon.withAlpha(150),
                                      color: neonTranslucent,
                                      shape: StadiumBorder(),
                                      onPressed: () {
                                        setState(() {
                                          print("pressed");
                                          isOpen = !isOpen;
                                          !isOpen ? controller.reverse() : controller.forward();
                                        });
                                      },
                                      child: Center(
                                          child: Row(
                                        children: [
                                          Icon(
                                            Icons.done,
                                            color: neonAccent,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Fertig",
                                            style: openButtonText.copyWith(color: neonAccent, fontSize: 14),
                                          ),
                                        ],
                                      )))
                                ],
                              )
                            : SizedBox(
                                height: 30,
                                child: StreamBuilder<int>(
                                    initialData: getIt<HiveDB>().ueberMillisekundenGesamt,
                                    stream: getIt<HiveDB>().ueberMillisekundenGesamtStream.stream,
                                    builder: (context, snapshot) {
                                      String text = snapshot.data!.isNegative ? "Stunden" : "Überstunden";

                                      Widget _widget = KeyedSubtree(
                                          key: ValueKey<String>(text),
                                          child: Text(
                                            text,
                                            style: TextStyle(fontSize: 20, color: Colors.blueGrey[300]),
                                          ));

                                      return PageTransitionSwitcher(
                                        reverse: text == "Stunden",
                                        transitionBuilder: (
                                          Widget child,
                                          Animation<double> primaryAnimation,
                                          Animation<double> secondaryAnimation,
                                        ) {
                                          return SharedAxisTransition(
                                            child: child,
                                            animation: primaryAnimation,
                                            secondaryAnimation: secondaryAnimation,
                                            transitionType: SharedAxisTransitionType.vertical,
                                            fillColor: Colors.transparent,
                                          );
                                        },
                                        child: _widget,
                                        duration: const Duration(milliseconds: 600),
                                      );
                                    }),
                              ),
                      ),
                      duration: const Duration(milliseconds: 600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: FadeTransition(
                opacity: animationFade,
                child: Text(
                  "Zeit bearbeiten",
                  style: TextStyle(color: gray, fontSize: 16),
                )),
          )
        ],
      ),
    );
  }
}
