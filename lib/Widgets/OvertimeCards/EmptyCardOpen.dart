import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';
import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../hiveClasses/Zeitnahme.dart';
import '../TimerTextWidget.dart';
import 'TagEditWidget.dart';

final getIt = GetIt.instance;

class EmptyCardOpen extends StatefulWidget {

  EmptyCardOpen ({
    @required this.i,
    @required this.index,
    @required this.zeitnahme,
    @required this.callback,
  });

  // index in Liste der Zeitnahmen // zeitenBox.length-1 ist gannz oben
  final int i;

  // Tatsächlicher Punkt in der ListView // 0 = ganz oben
  final int index;
  final Zeitnahme zeitnahme;
  final Function callback;

  @override
  _EmptyCardOpenState createState() => _EmptyCardOpenState();
}

class _EmptyCardOpenState extends State<EmptyCardOpen> {
  DateFormat uhrzeit = DateFormat("H:mm");

  DateFormat wochentag = DateFormat("EE", "de_DE");

  DateFormat datum = DateFormat("dd.MM", "de_DE");

  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");


  @override
  Widget build(BuildContext context) {
    //Tagesstunden in Millisekunden
    final int tagesMillisekunden = (getIt<Data>().tagesstunden * 3600000).truncate();
    final int tagesHours =
        Duration(milliseconds: tagesMillisekunden.abs()).inHours;
    final int tagesMinutes =
        Duration(milliseconds: tagesMillisekunden.abs()).inMinutes;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: grayTranslucent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        color: grayTranslucent,
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ]),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            tooltip: "Speichern und schliessen",
                            splashColor: grayAccent.withAlpha(80),
                            highlightColor:
                            grayAccent.withAlpha(50),
                            padding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(),
                            icon: Icon(Icons.done_rounded,
                                color: grayAccent, size: 30),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:100.0),
                      child: Column(
                        children: [
                          Text(
                            tag.format(widget.zeitnahme.day) + ", " + datum.format(widget.zeitnahme.day),
                            style: openCardDate.copyWith(color: gray),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TagEditWidget(
                            i:widget.i,
                            zeitnahme: widget.zeitnahme,
                            color: gray,
                            colorAccent: grayAccent,)
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "-",
                              style: openCardsNumbers,
                            ),Text(
                              tagesHours.toString(),
                              style: openCardsNumbers,
                            ),
                            Text(
                              ":",
                              style: openCardsNumbers,
                            ),
                            DoubleDigit(
                                i: tagesMinutes % 60,
                                style: openCardsNumbers)
                          ],
                        ),
                        Text(
                          "Stunden",
                          style: TextStyle(color: gray),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    onPressed: (){
                      if(widget.zeitnahme.tag == "Stundenabbau"){
                        getIt<HiveDB>().updateTag("Urlaub", widget.i);
                      }
                      getIt<HiveDB>().changeState("free", widget.i);
                      widget.callback();
                    },
                    splashColor: free.withAlpha(150),
                    highlightColor: free.withAlpha(80),
                    shape: const StadiumBorder(),
                    color: freeTranslucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.beach_access, color: freeAccent, size: 20,),
                          const SizedBox(width: 5),
                          Text("Urlaubstag", style: openButtonText.copyWith(
                              color: freeAccent
                          ),),
                        ],
                      ),
                    )
                ),
                const SizedBox(width: 12),
                FlatButton(
                    onPressed: (){
                      if(widget.zeitnahme.tag == "Stundenabbau"){
                        getIt<HiveDB>().updateTag("Bearbeitet", widget.i);
                      }
                      getIt<HiveDB>().changeState("edited", widget.i);
                      widget.callback();
                    },
                    splashColor: editColor.withAlpha(150),
                    highlightColor: editColor.withAlpha(80),
                    shape: const StadiumBorder(),
                    color: editColorTranslucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: editColor, size: 20,),
                          const SizedBox(width: 5),
                          Text("Zeit nachtragen", style: openButtonText.copyWith(
                              color: editColor
                          ),),
                        ],
                      ),
                    )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

