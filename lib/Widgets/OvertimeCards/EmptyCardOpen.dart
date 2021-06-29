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
  EmptyCardOpen({
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
    int weekday = getIt<Data>().individualTimes ? widget.zeitnahme.day.weekday - 1 : 0;
    int workMilliseconds = getIt<Data>().workingTime[weekday];

    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PhysicalModel(
                color: Theme.of(context).cardColor,
                elevation: 5,
                borderRadius: BorderRadius.circular(20),
                shadowColor: grayTranslucent,
                child: Container(
                  decoration: BoxDecoration(
                    color: grayTranslucent,
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                              highlightColor: grayAccent.withAlpha(50),
                              padding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(),
                              icon: Icon(Icons.done_rounded, color: Theme.of(context).colorScheme.onSurface, size: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100.0),
                        child: Column(
                          children: [
                            Text(
                              tag.format(widget.zeitnahme.day) + ", " + datum.format(widget.zeitnahme.day),
                              style: openCardDate.copyWith(color: Theme.of(context).colorScheme.onSurface),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TagEditWidget(
                              i: widget.i,
                              zeitnahme: widget.zeitnahme,
                              color: Theme.of(context).colorScheme.onSurface,
                              colorAccent: Theme.of(context).colorScheme.onSurface,
                            )
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
                                style: openCardsNumbers.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              ),
                              Text(
                                (workMilliseconds ~/ Duration.millisecondsPerHour).toString(),
                                style: openCardsNumbers.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              ),
                              Text(
                                ":",
                                style: openCardsNumbers.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              ),
                              DoubleDigit(
                                  i: (workMilliseconds ~/ Duration.millisecondsPerMinute) % 60,
                                  style: openCardsNumbers.copyWith(color: Theme.of(context).colorScheme.onSurface))
                            ],
                          ),
                          Text(
                            "Stunden",
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          onPressed: () {
                            if (widget.zeitnahme.tag == "Stundenabbau") {
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
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
                      const SizedBox(width: 12),
                      FlatButton(
                          onPressed: () {
                            if (widget.zeitnahme.tag == "Stundenabbau") {
                              getIt<HiveDB>().updateTag("Krankheitstag", widget.i);
                            }
                            getIt<HiveDB>().changeState("sickDay", widget.i);
                            widget.callback();
                          },
                          splashColor: editColor.withAlpha(150),
                          highlightColor: editColor.withAlpha(80),
                          shape: const StadiumBorder(),
                          color: Colors.red.withOpacity(0.2),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_hospital_rounded,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Krankheitstag",
                                  style: openButtonText.copyWith(color: Colors.redAccent),
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(width: 12),
                      FlatButton(
                          onPressed: () {
                            if (widget.zeitnahme.tag == "Stundenabbau") {
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
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: editColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Zeit nachtragen",
                                  style: openButtonText.copyWith(color: editColor),
                                ),
                              ],
                            ),
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
