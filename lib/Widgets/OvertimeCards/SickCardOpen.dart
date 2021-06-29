import 'package:Timo/Widgets/OvertimeCards/DefaultCardOpen/DefaultCardOpen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/HiveDB.dart';
import '../../Services/Theme.dart';
import '../../hiveClasses/Zeitnahme.dart';
import 'TagEditWidget.dart';

final getIt = GetIt.instance;

class SickCardOpen extends StatefulWidget {
  const SickCardOpen({
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
  _SickCardOpenState createState() => _SickCardOpenState();
}

class _SickCardOpenState extends State<SickCardOpen> {
  DateFormat uhrzeit = DateFormat("H:mm");

  DateFormat wochentag = DateFormat("EE", "de_DE");

  DateFormat datum = DateFormat("dd.MM", "de_DE");

  DateFormat tag = DateFormat(DateFormat.WEEKDAY, "de_DE");

  @override
  Widget build(BuildContext context) {
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
                shadowColor: sickAccent.withOpacity(0.15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
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
                              splashColor: freeAccent.withAlpha(80),
                              highlightColor: freeAccent.withAlpha(50),
                              padding: const EdgeInsets.all(0),
                              visualDensity: const VisualDensity(),
                              icon: const Icon(Icons.done_rounded, color: Colors.redAccent, size: 30),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tag.format(widget.zeitnahme.day) + ", " + datum.format(widget.zeitnahme.day),
                              style: openCardDate.copyWith(color: Colors.redAccent),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TagEditWidget(
                              i: widget.i,
                              zeitnahme: widget.zeitnahme,
                              color: Colors.redAccent,
                              colorAccent: freeAccent,
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "0:00",
                            style: openCardsNumbers.copyWith(color: Colors.redAccent),
                          ),
                          const Text(
                            "Überstunden",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: () {
                          if (widget.zeitnahme.startTimes.isNotEmpty) {
                            if (widget.zeitnahme.tag == "Krankheitstag") {
                              getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                            }
                            getIt<HiveDB>().changeState("default", widget.i);
                          } else {
                            if (widget.zeitnahme.tag == "Krankheitstag") {
                              getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                            }
                            getIt<HiveDB>().changeState("empty", widget.i);
                          }
                          widget.callback();
                        },
                        shape: const StadiumBorder(),
                        color: grayTranslucent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.replay_rounded,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Zurücksetzen",
                                style: openButtonText.copyWith(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 12),
                    FlatButton(
                        onPressed: () {
                          if (widget.zeitnahme.tag == "Krankheitstag") {
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
                          if (widget.zeitnahme.tag == "Krankheitstag") {
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
