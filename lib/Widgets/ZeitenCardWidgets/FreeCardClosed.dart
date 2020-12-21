import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:work_in_progress/Services/Data.dart';
import 'package:work_in_progress/Widgets/TimerTextWidget.dart';
import 'package:work_in_progress/hiveClasses/Zeitnahme.dart';

import '../../Services/HiveDB.dart';

final getIt = GetIt.instance;

class FreeCardClosed extends StatefulWidget {
  const FreeCardClosed({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    Key key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _FreeCardClosedState createState() => _FreeCardClosedState();
}

class _FreeCardClosedState extends State<FreeCardClosed> {
  var fullDate = new DateFormat('dd.MM.yyyy');
  var Uhrzeit = DateFormat("H:mm");
  var wochentag = new DateFormat("EE", "de_DE");
  var datum = DateFormat("dd.MM", "de_DE");
  Color _color = Color(0xffFFB77F);
  Color _colorAccent = Color(0xffFFA55F);
  Color _colorTranslucent = Color(0xffFFB77F).withAlpha(40);

  @override
  Widget build(BuildContext context) {
    if (widget.i >= 0) {
      final Zeitnahme _zeitnahme = widget.zeitnahme;
      final DateTime _day = _zeitnahme.day;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: _colorTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: TextStyle(color: _colorAccent, fontSize: 18.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: _colorAccent, fontSize: 12.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            AnimatedContainer(
              width: 260,
              duration: Duration(milliseconds: 1000),
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: _color),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Freier Tag",
                          style: TextStyle(fontSize: 18, color: _color),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: FlatButton(
                            onPressed: () {
                              getIt<HiveDB>().changeState("empty", widget.i);
                            },
                            child: Icon(
                              Icons.replay_rounded,
                              color: _colorAccent,
                              size: 28,
                            ),
                            splashColor: _colorAccent.withAlpha(80),
                            highlightColor: _colorAccent.withAlpha(50),
                            color: _colorTranslucent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
                            padding: EdgeInsets.all(5),
                            minWidth: 40,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Text("")),
                    Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      width: 65.0,
                      child: Text("0:00",
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.white)),
                      decoration: BoxDecoration(
                        color: _color,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      print("DefaultCard - wtf");
      return Container(
        child: Text("wtf"),
      );
    }
  }
}

class Ueberstunden extends StatelessWidget {
  const Ueberstunden({
    Key key,
    @required int index,
    @required int ueberMilliseconds,
  })  : _ueberMilliseconds = ueberMilliseconds,
        _index = index,
        super(key: key);

  final int _ueberMilliseconds;
  final int _index;

  @override
  Widget build(BuildContext context) {
    TextStyle greenStyle =
        Theme.of(context).textTheme.headline4.copyWith(color: Colors.white);
    TextStyle blueGreyStyle =
        Theme.of(context).textTheme.headline4.copyWith(color: Colors.white);

    return StreamBuilder(
        stream: getIt<Data>().isRunningStream.stream,
        builder: (context, snapshot) {
          Widget _widget;

          if (snapshot.data == false || _index > 0) {
            //TODO: Test what happens if Zeit = Tagesstunden
            if ((_ueberMilliseconds / 60000).truncate() == 0) {
              _widget = KeyedSubtree(
                key: ValueKey<int>(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 30.0,
                  width: 65.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          Duration(milliseconds: _ueberMilliseconds.abs())
                              .inHours
                              .toString(),
                          style: blueGreyStyle),
                      Text(":", style: blueGreyStyle),
                      DoubleDigit(
                          i: Duration(milliseconds: _ueberMilliseconds.abs())
                                  .inMinutes %
                              60,
                          style: blueGreyStyle)
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              );
            }
            if (_ueberMilliseconds.isNegative) {
              _widget = KeyedSubtree(
                key: ValueKey<int>(1),
                child: Container(
                  alignment: Alignment.center,
                  height: 30.0,
                  width: 65.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "-",
                        style: blueGreyStyle,
                      ),
                      Text(
                          Duration(milliseconds: _ueberMilliseconds.abs())
                              .inHours
                              .toString(),
                          style: blueGreyStyle),
                      Text(":", style: blueGreyStyle),
                      DoubleDigit(
                          i: Duration(milliseconds: _ueberMilliseconds.abs())
                                  .inMinutes %
                              60,
                          style: blueGreyStyle)
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              );
            } else {
              _widget = KeyedSubtree(
                key: ValueKey<int>(2),
                child: Container(
                  alignment: Alignment.center,
                  height: 30.0,
                  width: 65.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "+",
                        style: greenStyle,
                      ),
                      Text(
                          Duration(milliseconds: _ueberMilliseconds)
                              .inHours
                              .toString(),
                          style: greenStyle),
                      Text(":", style: greenStyle),
                      DoubleDigit(
                          i: Duration(milliseconds: _ueberMilliseconds.abs())
                                  .inMinutes %
                              60,
                          style: greenStyle)
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              );
            }
          } else {
            print("DefaultCardClosed - ueberMilli " +
                _ueberMilliseconds.toString());
            _widget = KeyedSubtree(
                key: ValueKey<int>(3),
                child: Container(
                  height: 30.0,
                  width: 65.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ));
          }
          return AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.easeOutExpo,
            duration: Duration(milliseconds: 300),
            child: _widget,
          );
        });
  }
}

class EndTimeWidget extends StatefulWidget {
  const EndTimeWidget({
    Key key,
    @required this.Uhrzeit,
    @required Zeitnahme zeitnahme,
  })  : _zeitnahme = zeitnahme,
        super(key: key);

  final DateFormat Uhrzeit;
  final Zeitnahme _zeitnahme;

  @override
  _EndTimeWidgetState createState() => _EndTimeWidgetState();
}

class _EndTimeWidgetState extends State<EndTimeWidget>
    with WidgetsBindingObserver {
  Timer endTracker = Timer.periodic(Duration(hours: 1), (timer) {});
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget._zeitnahme.endTimes.length ==
        widget._zeitnahme.startTimes.length) {
      endTracker.cancel();
      return Text(
        widget.Uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(
            widget._zeitnahme.endTimes.last)),
        style: TextStyle(fontSize: 18, color: Colors.blueGrey),
      );
    } else {
      _now = DateTime.now();
      endTracker.cancel();
      endTracker = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_now.minute != DateTime.now().minute) {
          setState(() {
            _now = DateTime.now();
            print("DefaultCard - time updated");
          });
        }
      });
      return Text(widget.Uhrzeit.format(_now),
          style: TextStyle(fontSize: 18, color: Colors.black.withAlpha(50)));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      print("DefaultCard - resumed");
      setState(() {
        _now = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    endTracker.cancel();
    super.dispose();
  }
}
