import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';
import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../hiveClasses/Zeitnahme.dart';
import '../TimerTextWidget.dart';

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

  DateFormat wochentag = new DateFormat("EE", "de_DE");

  DateFormat datum = DateFormat("dd.MM", "de_DE");

  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");


  @override
  Widget build(BuildContext context) {
    //Tagesstunden in Millisekunden
    int tagesMillisekunden = (getIt<Data>().tagesstunden * 3600000).truncate();
    int tagesHours =
        Duration(milliseconds: tagesMillisekunden.abs()).inHours;
    int tagesMinutes =
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
                        offset: Offset(0, 5),
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
                      children: [
                        IconButton(
                            splashColor: grayAccent.withAlpha(80),
                            highlightColor:
                            grayAccent.withAlpha(50),
                            padding: EdgeInsets.all(0),
                            visualDensity: VisualDensity(),
                            icon: Icon(Icons.close,
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
                            style: TextStyle(
                                fontSize: 42, color: gray),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Stundenabbau".toUpperCase(),
                            style: TextStyle(
                                color: gray,
                                fontSize: 18,
                                letterSpacing: 1
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
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
                          "Arbeitszeit",
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
                      getIt<HiveDB>().changeState("free", widget.i);
                      widget.callback();
                    },
                    splashColor: free.withAlpha(150),
                    highlightColor: free.withAlpha(80),
                    shape: StadiumBorder(),
                    color: freeTranslucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.beach_access, color: freeAccent, size: 20,),
                          SizedBox(width: 5),
                          Text("Urlaubstag", style: openButtonText.copyWith(
                              color: freeAccent
                          ),),
                        ],
                      ),
                    )
                ),
                SizedBox(width: 12),
                FlatButton(
                    onPressed: (){
                      getIt<HiveDB>().changeState("edited", widget.i);
                      widget.callback();
                    },
                    splashColor: editColor.withAlpha(150),
                    highlightColor: editColor.withAlpha(80),
                    shape: StadiumBorder(),
                    color: editColorTranslucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: editColor, size: 20,),
                          SizedBox(width: 5),
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

