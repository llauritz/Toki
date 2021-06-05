import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../hiveClasses/Zeitnahme.dart';
import '../TimerTextWidget.dart';
import 'TagEditWidget.dart';

final getIt = GetIt.instance;

class EditedCardOpen extends StatefulWidget {
  const EditedCardOpen({
    required this.i,
    required this.index,
    required this.zeitnahme,
    required this.callback,
  });

  // index in Liste der Zeitnahmen // zeitenBox.length-1 ist gannz oben
  final int i;

  // Tatsächlicher Punkt in der ListView // 0 = ganz oben
  final int index;
  final Zeitnahme zeitnahme;
  final Function callback;

  @override
  _EditedCardOpenState createState() => _EditedCardOpenState();
}

class _EditedCardOpenState extends State<EditedCardOpen> {
  DateFormat uhrzeit = DateFormat("H:mm");

  DateFormat wochentag = DateFormat("EE", "de_DE");

  DateFormat datum = DateFormat("dd.MM", "de_DE");

  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");

  int changeMilli = 0;
  int editMilli = 0;

  @override
  void initState() {
    changeMilli = widget.zeitnahme.editMilli;
    editMilli = widget.zeitnahme.editMilli;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int editHours = (editMilli / Duration.millisecondsPerHour).truncate();
    final int editMinutes =
        (editMilli / Duration.millisecondsPerMinute).truncate();

    final int ueberMilli = widget.zeitnahme.getUeberstunden();
    final int ueberHours =
        (ueberMilli / Duration.millisecondsPerHour).truncate();
    final int ueberMinutes =
        (ueberMilli / Duration.millisecondsPerMinute).truncate();

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
                    color: editColorTranslucent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        color: editColorTranslucent.withAlpha(150),
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
                            splashColor: editColor.withAlpha(80),
                            highlightColor: editColor.withAlpha(50),
                            padding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(),
                            icon: Icon(Icons.done_rounded,
                                color: editColor, size: 30),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 65.0),
                      child: Column(
                        children: [
                          Text(
                            tag.format(widget.zeitnahme.day) +
                                ", " +
                                datum.format(widget.zeitnahme.day),
                            style: openCardDate.copyWith(color: editColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TagEditWidget(
                            i: widget.i,
                            zeitnahme: widget.zeitnahme,
                            color: editColor,
                            colorAccent: editColor,
                          ),
                          const SizedBox(height: 30),
                          Slider.adaptive(
                            value: changeMilli * 1.0,
                            min: 0,
                            max: Duration.millisecondsPerHour * 12.0,
                            divisions: 24,
                            onChanged: (double value) {
                              setState(() {
                                changeMilli = value.truncate();
                                editMilli = value.truncate();
                              });
                            },
                            onChangeEnd: (double value) {
                              setState(() {
                                getIt<HiveDB>().updateEditMilli(
                                    value.truncate(), widget.i);
                              });
                            },
                          )
                        ],
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
                                  editHours.toString(),
                                  style: openCardsNumbers.copyWith(
                                      color: editColor),
                                ),
                                Text(":",
                                    style: openCardsNumbers.copyWith(
                                        color: editColor)),
                                DoubleDigit(
                                    i: editMinutes % 60,
                                    style: openCardsNumbers.copyWith(
                                        color: editColor))
                              ],
                            ),
                            Text(
                              "Stunden",
                              style: TextStyle(color: editColor),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  ueberHours.toString(),
                                  style: openCardsNumbers.copyWith(
                                      color: editColor),
                                ),
                                Text(":",
                                    style: openCardsNumbers.copyWith(
                                        color: editColor)),
                                DoubleDigit(
                                    i: ueberMinutes % 60,
                                    style: openCardsNumbers.copyWith(
                                        color: editColor))
                              ],
                            ),
                            Text(
                              "Überstunden",
                              style: TextStyle(color: editColor),
                            ),
                          ],
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
                    onPressed: () {
                      if (widget.zeitnahme.startTimes.isNotEmpty) {
                        if (widget.zeitnahme.tag == "Bearbeitet") {
                          getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                        }
                        getIt<HiveDB>().changeState("default", widget.i);
                      } else {
                        if (widget.zeitnahme.tag == "Bearbeitet") {
                          getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                        }
                        getIt<HiveDB>().changeState("empty", widget.i);
                      }
                      widget.callback();
                    },
                    shape: const StadiumBorder(),
                    color: grayTranslucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.replay_rounded,
                            color: grayAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Zurücksetzen",
                            style: openButtonText.copyWith(color: grayAccent),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(width: 12),
                FlatButton(
                    onPressed: () {
                      if (widget.zeitnahme.tag == "Bearbeitet") {
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.beach_access,
                            color: freeAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Urlaubstag",
                            style: openButtonText.copyWith(color: freeAccent),
                          ),
                        ],
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
