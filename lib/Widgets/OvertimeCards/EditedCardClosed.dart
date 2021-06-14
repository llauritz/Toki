import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/HiveDB.dart';
import '../../Widgets/TimerTextWidget.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class EditedCardClosedStl extends StatelessWidget {
  const EditedCardClosedStl({Key? key, required this.i, required this.index, required this.zeitnahme}) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  Widget build(BuildContext context) {
    final DateFormat fullDate = DateFormat('dd.MM.yyyy');
    final DateFormat uhrzeit = DateFormat("H:mm");
    final DateFormat wochentag = DateFormat("EE", "de_DE");
    final DateFormat datum = DateFormat("dd.MM", "de_DE");
    //getIt<HiveDB>().updateTag("Urlaub", widget.i);

    if (i >= 0) {
      final int ueberMilli = zeitnahme.getUeberstunden();
      final int ueberHours = (ueberMilli / Duration.millisecondsPerHour).truncate();
      final int overMinutes = (ueberMilli / Duration.millisecondsPerMinute).truncate();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: editColorTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(zeitnahme.day).substring(0, 2),
                    style: TextStyle(color: editColor, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(zeitnahme.day),
                    style: TextStyle(color: editColor, fontSize: 11.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Container(
              width: 240,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: editColor),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              child: Text(
                                zeitnahme.tag.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: editColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FlatButton(
                              onPressed: () {
                                if (zeitnahme.startTimes.isNotEmpty) {
                                  getIt<HiveDB>().changeState("default", i);
                                } else {
                                  getIt<HiveDB>().changeState("empty", i);
                                }
                                if (zeitnahme.tag == "Bearbeitet") {
                                  getIt<HiveDB>().updateTag("Stundenabbau", i);
                                }
                              },
                              child: Icon(
                                Icons.replay_rounded,
                                color: editColor,
                                size: 22,
                              ),
                              splashColor: editColor.withAlpha(80),
                              highlightColor: editColor.withAlpha(50),
                              color: editColorTranslucent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
                              padding: const EdgeInsets.all(5),
                              minWidth: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      width: 65.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!ueberMilli.isNegative)
                            const Text(
                              "+",
                              style: closedCardsNumbers,
                            ),
                          Text(
                            ueberHours.toString(),
                            style: closedCardsNumbers,
                          ),
                          const Text(":", style: closedCardsNumbers),
                          DoubleDigit(i: overMinutes.abs() % 60, style: closedCardsNumbers)
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: editColor,
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
        child: const Text("wtf"),
      );
    }
  }
}


/*
class EditedCardClosed extends StatefulWidget {
  const EditedCardClosed({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    Key key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _EditedCardClosedState createState() => _EditedCardClosedState();
}

class _EditedCardClosedState extends State<EditedCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");

  @override
  Widget build(BuildContext context) {

    //getIt<HiveDB>().updateTag("Urlaub", widget.i);

    if (widget.i >= 0) {

      final int ueberMilli = widget.zeitnahme.getUeberstunden();
      final int ueberHours = (ueberMilli/Duration.millisecondsPerHour).round();
      final int overMinutes = (ueberMilli/Duration.millisecondsPerMinute).round();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: editColorTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(widget.zeitnahme.day).substring(0, 2),
                    style: TextStyle(color: editColor, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(widget.zeitnahme.day),
                    style: TextStyle(color: editColor, fontSize: 11.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Container(
              width: 240,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: editColor),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              child: Text(
                                widget.zeitnahme.tag.toString(),overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: editColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FlatButton(
                              onPressed: () {
                                if(widget.zeitnahme.startTimes.isNotEmpty){
                                  getIt<HiveDB>().changeState("default", widget.i);
                                }else{
                                  getIt<HiveDB>().changeState("empty", widget.i);
                                }
                                if(widget.zeitnahme.tag == "Bearbeitet"){
                                  getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                                }
                              },
                              child: Icon(
                                Icons.replay_rounded,
                                color: editColor,
                                size: 22,
                              ),
                              splashColor: editColor.withAlpha(80),
                              highlightColor: editColor.withAlpha(50),
                              color: editColorTranslucent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1000)),
                              padding: const EdgeInsets.all(5),
                              minWidth: 40,
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30.0,
                      width: 65.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(!ueberMilli.isNegative)
                          const Text(
                                 "+",
                                 style: closedCardsNumbers,
                                ),
                          Text(
                            ueberHours.toString(),
                            style: closedCardsNumbers,
                          ),
                          const Text(
                              ":",
                              style: closedCardsNumbers
                          ),
                          DoubleDigit(
                              i: overMinutes % 60,
                              style: closedCardsNumbers)
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: editColor,
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
        child: const Text("wtf"),
      );
    }
  }
}*/
