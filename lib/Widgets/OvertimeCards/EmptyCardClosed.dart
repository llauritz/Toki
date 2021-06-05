import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';
import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../Widgets/TimerTextWidget.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class EmptyCardClosed extends StatefulWidget {
  const EmptyCardClosed({
    required this.i,
    required this.index,
    required this.zeitnahme,
    Key? key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _EmptyCardClosedState createState() => _EmptyCardClosedState();
}

class _EmptyCardClosedState extends State<EmptyCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat Uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");

  //Tagesstunden in Millisekunden
  final int _tagesMillisekunden = (getIt<Data>().tagesstunden * 3600000).truncate();

  @override
  Widget build(BuildContext context) {
    if (widget.i >= 0) {
      final Zeitnahme _zeitnahme = widget.zeitnahme;
      final DateTime _day = _zeitnahme.day;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: grayTranslucent.withAlpha(100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: TextStyle(color: gray, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: gray, fontSize: 11.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            AnimatedContainer(
              width: 240,
              duration: const Duration(milliseconds: 1000),
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: grayTranslucent),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                      child: FlatButton(
                          minWidth: 0,
                          splashColor: freeAccent.withAlpha(80),
                          highlightColor: freeAccent.withAlpha(50),
                          color: freeTranslucent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000)),
                          onPressed: () {
                            if(widget.zeitnahme.tag == "Stundenabbau"){
                              getIt<HiveDB>().updateTag("Urlaub", widget.i);
                            }
                            getIt<HiveDB>().changeState("free", widget.i);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.beach_access,
                                size: 18,
                                color: freeAccent,
                              ),
                              const Text(
                                "Urlaub",
                                style: TextStyle(
                                    fontFamily: "BandeinsSansRegular",
                                    color: freeAccent, fontSize: 11.0),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(3, 3, 0, 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: editColorTranslucent
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: editColor,
                              ),
                              Text(
                                "Bearbeiten",
                                style: TextStyle(
                                    fontFamily: "BandeinsSansRegular",
                                    color: editColor, fontSize: 11.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: Text("")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "-",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: gray),
                        ),
                        Text(
                            Duration(milliseconds: _tagesMillisekunden.abs())
                                .inHours
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: gray)),
                        Text(":",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: gray)),
                        DoubleDigit(
                            i: Duration(milliseconds: _tagesMillisekunden.abs())
                                    .inMinutes %
                                60,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: gray))
                      ],
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
        child: const Text('wtf'),
      );
    }
  }
}