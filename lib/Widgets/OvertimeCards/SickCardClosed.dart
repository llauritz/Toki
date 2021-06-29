import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/HiveDB.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class SickCardClosed extends StatefulWidget {
  const SickCardClosed({
    required this.i,
    required this.index,
    required this.zeitnahme,
    Key? key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _SickCardClosedState createState() => _SickCardClosedState();
}

class _SickCardClosedState extends State<SickCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat Uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");

  @override
  Widget build(BuildContext context) {
    //getIt<HiveDB>().updateTag("Urlaub", widget.i);

    if (widget.i >= 0) {
      final Zeitnahme _zeitnahme = widget.zeitnahme;
      final DateTime _day = _zeitnahme.day;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: sickTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(_day).substring(0, 2),
                    style: const TextStyle(color: sickAccent, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(_day),
                    style: const TextStyle(color: sickAccent, fontSize: 11.0),
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
                border: Border.all(width: 2.0, color: sickAccent),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              child: Text(
                                _zeitnahme.tag.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, color: sickAccent),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: FlatButton(
                              onPressed: () {
                                if (widget.zeitnahme.startTimes.isNotEmpty) {
                                  getIt<HiveDB>().changeState("default", widget.i);
                                } else {
                                  getIt<HiveDB>().changeState("empty", widget.i);
                                }
                                if (widget.zeitnahme.tag == "Krankheitstag") {
                                  getIt<HiveDB>().updateTag("Stundenabbau", widget.i);
                                }
                              },
                              child: const Icon(
                                Icons.replay_rounded,
                                color: sickAccent,
                                size: 24,
                              ),
                              splashColor: sickAccent.withAlpha(80),
                              highlightColor: sickAccent.withAlpha(50),
                              color: sickTranslucent,
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
                      child: Text("0:00", style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                      decoration: BoxDecoration(
                        color: sickAccent,
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
        child: Text("wtf"),
      );
    }
  }
}
