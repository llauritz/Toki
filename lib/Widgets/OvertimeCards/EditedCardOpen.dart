import 'package:Toki/Widgets/OvertimeCards/DefaultCardOpen/DefaultCardOpen.dart';
import 'package:Toki/Widgets/Settings/WorkTimePicker.dart';
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
  bool divisions = true;

  @override
  void initState() {
    divisions = widget.zeitnahme.editMilli / Duration.millisecondsPerHour % 0.5 == 0;
    changeMilli = widget.zeitnahme.editMilli;
    editMilli = widget.zeitnahme.editMilli;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int editHours = (editMilli / Duration.millisecondsPerHour).truncate();
    final int editMinutes = (editMilli / Duration.millisecondsPerMinute).truncate();

    final int ueberMilli = widget.zeitnahme.getUeberstunden();
    final int ueberHours = (ueberMilli / Duration.millisecondsPerHour).truncate();
    final int ueberMinutes = (ueberMilli / Duration.millisecondsPerMinute).truncate();

    return Container(
      color: Theme.of(context).cardColor,
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
                            splashColor: editColor.withAlpha(80),
                            highlightColor: editColor.withAlpha(50),
                            padding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(),
                            icon: Icon(Icons.done_rounded, color: editColor, size: 30),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 65.0),
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tag.format(widget.zeitnahme.day) + ", " + datum.format(widget.zeitnahme.day),
                              style: openCardDate.copyWith(color: editColor),
                            ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      overlayShape: SliderComponentShape.noOverlay,
                                      trackHeight: 7,
                                      trackShape: WorktimeSliderTrackShape(),
                                      thumbShape: WorkTimeSliderThumbRect(
                                          min: 0,
                                          max: widget.zeitnahme.editMilli < (12.0 * Duration.millisecondsPerHour)
                                              ? 12
                                              : widget.zeitnahme.editMilli / Duration.millisecondsPerHour,
                                          thumbHeight: 40.0,
                                          thumbWidth: 100.0,
                                          thumbRadius: 0,
                                          color: editColor,
                                          thumbBackground: editColor,
                                          textcolor: Theme.of(context).colorScheme.onPrimary,
                                          enabled: true),
                                      activeTickMarkColor: Colors.transparent,
                                      inactiveTickMarkColor: Colors.transparent,
                                      inactiveTrackColor: editColor.withAlpha(50),
                                      activeTrackColor: editColor.withAlpha(200),
                                    ),
                                    child: Slider(
                                      value: widget.zeitnahme.editMilli * 1.0,
                                      onChangeStart: (_) {
                                        divisions = true;
                                      },
                                      onChanged: (newTagesstunden) {
                                        setState(() {
                                          getIt<HiveDB>().updateEditMilli(newTagesstunden.round(), widget.i);
                                        });
                                      },
                                      onChangeEnd: (newTagesstunden) {
                                        if (newTagesstunden / Duration.millisecondsPerHour % 0.5 != 0) {
                                          newTagesstunden =
                                              ((newTagesstunden / Duration.millisecondsPerHour * 2).round() / 2) * Duration.millisecondsPerHour;
                                        }
                                        widget.zeitnahme.editMilli = newTagesstunden.toInt();
                                        setState(() {
                                          getIt<HiveDB>().updateEditMilli(newTagesstunden.toInt(), widget.i);
                                        });
                                      },
                                      min: 0,
                                      max: widget.zeitnahme.editMilli < (12.0 * Duration.millisecondsPerHour)
                                          ? 12.0 * Duration.millisecondsPerHour
                                          : widget.zeitnahme.editMilli * 1.0,
                                      divisions: divisions ? 24 : null,
                                      //label: "$tagesstunden Stunden",
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.keyboard_alt_rounded),
                                  color: editColor,
                                  onPressed: () async {
                                    int hours = widget.zeitnahme.editMilli ~/ Duration.millisecondsPerHour;
                                    int minutes =
                                        (widget.zeitnahme.editMilli - hours * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                                    TimeOfDay? newTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(hour: hours, minute: minutes),
                                        helpText: "Arbeitszeit auswählen".toUpperCase());
                                    if (newTime != null) {
                                      widget.zeitnahme.editMilli =
                                          newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute;
                                      getIt<HiveDB>().updateEditMilli(widget.zeitnahme.editMilli, widget.i);
                                      divisions = widget.zeitnahme.editMilli / Duration.millisecondsPerHour % 0.5 == 0;
                                      setState(() {});
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
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
                                  Duration(milliseconds: widget.zeitnahme.editMilli).inHours.toString(),
                                  style: openCardsNumbers.copyWith(color: editColor),
                                ),
                                Text(":", style: openCardsNumbers.copyWith(color: editColor)),
                                DoubleDigit(
                                    i: Duration(milliseconds: widget.zeitnahme.editMilli).inMinutes % 60,
                                    style: openCardsNumbers.copyWith(color: editColor))
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
                                if (widget.zeitnahme.getUeberstunden().isNegative) Text("-", style: openCardsNumbers.copyWith(color: editColor)),
                                Text(
                                  (widget.zeitnahme.getUeberstunden().abs() ~/ Duration.millisecondsPerHour).toString(),
                                  style: openCardsNumbers.copyWith(color: editColor),
                                ),
                                Text(":", style: openCardsNumbers.copyWith(color: editColor)),
                                DoubleDigit(
                                    i: ((widget.zeitnahme.getUeberstunden().abs() ~/ Duration.millisecondsPerMinute) % 60),
                                    style: openCardsNumbers.copyWith(color: editColor))
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
                          if (widget.zeitnahme.tag == "Bearbeitet") {
                            getIt<HiveDB>().updateTag("Krankheitstag", widget.i);
                          }
                          getIt<HiveDB>().changeState("sickDay", widget.i);
                          widget.callback();
                        },
                        splashColor: Colors.red.withAlpha(150),
                        highlightColor: Colors.red.withAlpha(80),
                        shape: const StadiumBorder(),
                        color: Colors.red.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
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
