import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:work_in_progress/Services/Theme.dart';
import 'package:work_in_progress/Widgets/TimerTextWidget.dart';
import 'package:work_in_progress/hiveClasses/Zeitnahme.dart';

import '../../../Services/HiveDB.dart';
import 'TimesList.dart';

final getIt = GetIt.instance;

class DefaultCardOpen extends StatefulWidget {
  const DefaultCardOpen({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    Key key,
  }) : super(key: key);

  // index in Liste der Zeitnahmen // zeitenBox.length-1 ist gannz oben
  final int i;

  // Tatsächlicher Punkt in der ListView // 0 = ganz oben
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _DefaultCardOpenState createState() => _DefaultCardOpenState();
}

class _DefaultCardOpenState extends State<DefaultCardOpen> {
  Color _color;
  Color _colorAccent;
  Color _colorTranslucent;
  double _width = 260;
  DateFormat uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = new DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");
  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");

  GlobalKey _toolTipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: getIt<HiveDB>().listChangesStream.stream,
        builder: (context, snapshot) {
          int ueberMilliseconds = widget.zeitnahme.getUeberstunden();
          if (!ueberMilliseconds.isNegative) {
            _color = Colors.tealAccent;
            _colorAccent = Color(0xff00FFDC);
            _colorTranslucent = Color(0xffE4FFFB);
          } else {
            _color = Colors.blueGrey[300];
            _colorAccent = Colors.blueGrey[300];
            _colorTranslucent = Colors.blueGrey[50];
          }

          final Zeitnahme _zeitnahme = widget.zeitnahme;
          final DateTime _day = _zeitnahme.day;

          int elapsedMilliseconds = _zeitnahme.getElapsedTime();
          int elapsedHours =
              Duration(milliseconds: elapsedMilliseconds).inHours;
          int elapsedMinutes =
              Duration(milliseconds: elapsedMilliseconds).inMinutes;

          int pauseMilliseconds =
              _zeitnahme.getPause() + _zeitnahme.getKorrektur();
          int pauseHours = Duration(milliseconds: pauseMilliseconds).inHours;
          int pauseMinutes =
              Duration(milliseconds: pauseMilliseconds).inMinutes;

          int ueberHours =
              Duration(milliseconds: ueberMilliseconds.abs()).inHours;
          int ueberMinutes =
              Duration(milliseconds: ueberMilliseconds.abs()).inMinutes;

          print("ueberHoras $ueberHours");
          print("ueberMinutes $ueberMinutes");

          TextStyle numbers = TextStyle(color: _colorAccent, fontSize: 32);

          return Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: _colorTranslucent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 5),
                                  color: _colorTranslucent.withAlpha(150),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                )
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      splashColor: _colorAccent.withAlpha(80),
                                      highlightColor:
                                          _colorAccent.withAlpha(50),
                                      padding: EdgeInsets.all(0),
                                      visualDensity: VisualDensity(),
                                      icon: Icon(Icons.close,
                                          color: _colorAccent, size: 30),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                  tag.format(_day) + ", " + datum.format(_day),
                                  style: TextStyle(
                                      fontSize: 42, color: _colorAccent),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            elapsedHours.toString(),
                                            style: numbers,
                                          ),
                                          Text(
                                            ":",
                                            style: numbers,
                                          ),
                                          DoubleDigit(
                                              i: elapsedMinutes % 60,
                                              style: numbers)
                                        ],
                                      ),
                                      Text(
                                        "Arbeitszeit",
                                        style: TextStyle(color: _colorAccent),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Column(
                                        children: [
                                          //TODO: Nur anzeigen, wenn nicht erstes Element + isRunning true

                                          Row(
                                            children: [
                                              if (ueberMilliseconds.isNegative)
                                                Text("-", style: numbers),
                                              Text(
                                                ueberHours.toString(),
                                                style: numbers,
                                              ),
                                              Text(
                                                ":",
                                                style: numbers,
                                              ),
                                              DoubleDigit(
                                                  i: ueberMinutes % 60,
                                                  style: numbers)
                                            ],
                                          ),
                                          Text(
                                            "Überstunden",
                                            style:
                                                TextStyle(color: _colorAccent),
                                          ),
                                        ],
                                      )),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_zeitnahme.getKorrektur() > 0) {
                                            final dynamic tooltip =
                                                _toolTipKey.currentState;
                                            tooltip.ensureTooltipVisible();
                                          }
                                        },
                                        child: Tooltip(
                                          textStyle: TextStyle(
                                              color: Colors.blueGrey[700]),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 5),
                                                    color: Colors.black12,
                                                    blurRadius: 10)
                                              ]),
                                          key: _toolTipKey,
                                          verticalOffset: 40,
                                          message: "Pause korrigiert",
                                          child: Row(
                                            children: [
                                              Text(
                                                pauseHours.toString(),
                                                style: numbers.copyWith(
                                                    color: _zeitnahme
                                                                .getKorrektur() >
                                                            0
                                                        ? editColor
                                                        : _colorAccent),
                                              ),
                                              Text(
                                                ":",
                                                style: numbers.copyWith(
                                                    color: _zeitnahme
                                                                .getKorrektur() >
                                                            0
                                                        ? editColor
                                                        : _colorAccent),
                                              ),
                                              DoubleDigit(
                                                  i: pauseMinutes % 60,
                                                  style: numbers.copyWith(
                                                      color: _zeitnahme
                                                                  .getKorrektur() >
                                                              0
                                                          ? editColor
                                                          : _colorAccent))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Pause",
                                        style: TextStyle(
                                            color: _zeitnahme.getKorrektur() > 0
                                                ? editColor
                                                : _colorAccent),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 7,
                      child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: TimesList(
                              zeitnahme: _zeitnahme,
                              uhrzeit: uhrzeit,
                              widget: widget))),
                ],
              ),
            ),
          );
        });
  }
}
