import 'dart:async';

import 'package:Toki/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';
import '../../Widgets/TimerTextWidget.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class FirstCardClosed extends StatefulWidget {
  const FirstCardClosed({
    required this.i,
    required this.index,
    required this.zeitnahme,
    required this.isRunning,
    Key? key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;
  final bool isRunning;

  @override
  _FirstCardClosedState createState() => _FirstCardClosedState();
}

class _FirstCardClosedState extends State<FirstCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat Uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");
  Color _color = Colors.black;
  Color _colorAccent = Colors.black;
  Color _colorTranslucent = Colors.black;
  double _width = 240;
  int keyInt = 0;

  @override
  Widget build(BuildContext context) {
    final Zeitnahme _zeitnahme = widget.zeitnahme;
    final DateTime _day = _zeitnahme.day;

    final int ueberMilliseconds = widget.zeitnahme.getUeberstunden();
    if (!ueberMilliseconds.isNegative && !widget.isRunning) {
      _color = neon;
      _colorAccent = neonAccent;
      _colorTranslucent = neonTranslucent;
      keyInt = 0;
    } else {
      _color = gray;
      _colorAccent = Theme.of(context).colorScheme.onSurface;
      _colorTranslucent = grayTranslucent;
      keyInt = 1;
    }

    if (widget.index == 0 && widget.isRunning) {
      _width = 150;
      print("DefaultCardClosed - width $_width");
    } else {
      _width = 240;
      print("DefaultCardClosed - width $_width");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: _colorTranslucent,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                child: KeyedSubtree(
                  key: ValueKey<int>(keyInt),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        wochentag.format(_day).substring(0, 2),
                        style: TextStyle(color: _colorAccent, fontSize: 16.0),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        datum.format(_day),
                        style: TextStyle(color: _colorAccent, fontSize: 11.0),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              )),
          const SizedBox(
            width: 20.0,
          ),
          AnimatedContainer(
            width: _width,
            curve: getIt<Data>().isRunning ? Curves.easeInOutCubic : Curves.ease,
            duration: const Duration(milliseconds: 700),
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: _color),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
              child: Row(
                children: [
                  Text(
                    Uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(_zeitnahme.startTimes[0])),
                    style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
                    child: Icon(
                      Icons.east_rounded,
                      size: 20.0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  EndTimeWidget(
                    Uhrzeit: Uhrzeit,
                    zeitnahme: _zeitnahme,
                    index: widget.index,
                  ),
                  const Expanded(child: Text("")),
                  Ueberstunden(ueberMilliseconds: ueberMilliseconds, index: widget.index, isRunning: widget.isRunning)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Ueberstunden extends StatelessWidget {
  const Ueberstunden({
    Key? key,
    required int index,
    required int ueberMilliseconds,
    required bool isRunning,
  })  : _ueberMilliseconds = ueberMilliseconds,
        _index = index,
        _isRunning = isRunning,
        super(key: key);

  final int _ueberMilliseconds;
  final int _index;
  final bool _isRunning;

  @override
  Widget build(BuildContext context) {
    TextStyle greenStyle = Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    TextStyle blueGreyStyle = Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onPrimary);

    Widget _widget;

    if (_isRunning == false || _index > 0) {
      //TODO: Test what happens if Zeit = Tagesstunden
      if ((_ueberMilliseconds / 60000).round() == 0) {
        _widget = KeyedSubtree(
          key: const ValueKey<int>(0),
          child: Container(
            alignment: Alignment.center,
            height: 30.0,
            width: 65.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Duration(milliseconds: _ueberMilliseconds.abs()).inHours.toString(), style: blueGreyStyle),
                Text(":", style: blueGreyStyle),
                DoubleDigit(i: Duration(milliseconds: _ueberMilliseconds.abs()).inMinutes % 60, style: blueGreyStyle)
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
          key: const ValueKey<int>(1),
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
                Text(Duration(milliseconds: _ueberMilliseconds.abs()).inHours.toString(), style: blueGreyStyle),
                Text(":", style: blueGreyStyle),
                DoubleDigit(i: Duration(milliseconds: _ueberMilliseconds.abs()).inMinutes % 60, style: blueGreyStyle)
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
          key: const ValueKey<int>(2),
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
                Text(Duration(milliseconds: _ueberMilliseconds).inHours.toString(), style: greenStyle),
                Text(":", style: greenStyle),
                DoubleDigit(i: Duration(milliseconds: _ueberMilliseconds.abs()).inMinutes % 60, style: greenStyle)
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
      print("DefaultCardClosed - ueberMilli " + _ueberMilliseconds.toString());
      _widget = KeyedSubtree(key: const ValueKey<int>(3), child: Container());
    }
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
      duration: const Duration(milliseconds: 1000),
    );
  }
}

class EndTimeWidget extends StatefulWidget {
  const EndTimeWidget({Key? key, required this.Uhrzeit, required Zeitnahme zeitnahme, required int index})
      : _zeitnahme = zeitnahme,
        _index = index,
        super(key: key);

  final DateFormat Uhrzeit;
  final Zeitnahme _zeitnahme;
  final int _index;

  @override
  _EndTimeWidgetState createState() => _EndTimeWidgetState();
}

class _EndTimeWidgetState extends State<EndTimeWidget> {
  Timer endTracker = Timer.periodic(const Duration(hours: 1), (timer) {});
  DateTime _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Widget _widget;

    if (widget._zeitnahme.endTimes.length == widget._zeitnahme.startTimes.length) {
      endTracker.cancel();
      _widget = Text(
        widget.Uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(widget._zeitnahme.endTimes.last)),
        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
        key: ValueKey<int>(widget._zeitnahme.endTimes.last),
      );
    } else {
      _now = DateTime.now();
      endTracker.cancel();
      endTracker = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (_now.minute != DateTime.now().minute) {
          setState(() {
            _now = DateTime.now();
            print("DefaultCard - time updated");
          });
        }
      });
      _widget = Text(
        widget.Uhrzeit.format(_now),
        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
        key: ValueKey<int>(DateTime.now().millisecondsSinceEpoch),
      );
    }

    return widget._index > 0
        ? _widget
        : PageTransitionSwitcher(
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
  }

  @override
  void dispose() {
    endTracker.cancel();
    super.dispose();
  }
}
