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
    required this.openCard,
    Key? key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;
  final Function openCard;

  @override
  _EmptyCardClosedState createState() => _EmptyCardClosedState();
}

class _EmptyCardClosedState extends State<EmptyCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat Uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");

  //Tagesstunden in Millisekunden

  @override
  Widget build(BuildContext context) {
    BoxDecoration tooltipDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).cardColor,
        boxShadow: [const BoxShadow(offset: const Offset(0, 5), color: Colors.black12, blurRadius: 10)]);

    int weekday = getIt<Data>().individualTimes ? widget.zeitnahme.day.weekday - 1 : 0;
    int workMilliseconds = getIt<Data>().workingTime[weekday];

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
                color: grayTranslucent.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75), fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75), fontSize: 11.0),
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
                    Tooltip(
                      verticalOffset: 20,
                      preferBelow: false,
                      decoration: tooltipDecoration,
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      message: "Urlaubstag",
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: FlatButton(
                            minWidth: 46,
                            padding: EdgeInsets.zero,
                            splashColor: freeAccent.withAlpha(80),
                            highlightColor: freeAccent.withAlpha(50),
                            color: freeTranslucent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
                            onPressed: () {
                              if (widget.zeitnahme.tag == "Stundenabbau") {
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
                              ],
                            )),
                      ),
                    ),
                    Tooltip(
                      verticalOffset: 20,
                      preferBelow: false,
                      decoration: tooltipDecoration,
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      message: "Krankheitstag",
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: FlatButton(
                            minWidth: 46,
                            padding: EdgeInsets.zero,
                            splashColor: sickAccent.withAlpha(80),
                            highlightColor: sickAccent.withAlpha(50),
                            color: sickTranslucent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
                            onPressed: () {
                              if (widget.zeitnahme.tag == "Stundenabbau") {
                                getIt<HiveDB>().updateTag("Krankheitstag", widget.i);
                              }
                              getIt<HiveDB>().changeState("sickDay", widget.i);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.local_hospital_rounded,
                                  size: 18,
                                  color: sickAccent,
                                ),
                              ],
                            )),
                      ),
                    ),
                    Tooltip(
                      verticalOffset: 20,
                      preferBelow: false,
                      decoration: tooltipDecoration,
                      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      message: "Zeit nachtragen",
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: FlatButton(
                            minWidth: 46,
                            padding: EdgeInsets.zero,
                            splashColor: editColor.withAlpha(80),
                            highlightColor: editColor.withAlpha(50),
                            color: editColorTranslucent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
                            onPressed: () async {
                              if (widget.zeitnahme.tag == "Stundenabbau") {
                                getIt<HiveDB>().updateTag("Bearbeitet", widget.i);
                              }
                              getIt<HiveDB>().changeState("edited", widget.i);
                              await Future.delayed(Duration(milliseconds: 300));
                              widget.openCard();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit_rounded,
                                  size: 18,
                                  color: editColor,
                                ),
                              ],
                            )),
                      ),
                    ),
                    const Expanded(child: Text("")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "-",
                          style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75)),
                        ),
                        Text(Duration(milliseconds: workMilliseconds.abs()).inHours.toString(),
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75))),
                        Text(":",
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75))),
                        DoubleDigit(
                            i: Duration(milliseconds: workMilliseconds.abs()).inMinutes % 60,
                            style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75)))
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
