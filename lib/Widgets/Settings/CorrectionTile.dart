import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/hiveClasses/Correction.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../Services/Data.dart';
import 'BreakCorrection.dart';

class CorrectionTile extends StatefulWidget {
  const CorrectionTile({Key? key, required this.correction, required this.closeCallback, required this.index}) : super(key: key);
  final Correction correction;
  final Function closeCallback;
  final int index;

  @override
  _CorrectionTileState createState() => _CorrectionTileState();
}

class _CorrectionTileState extends State<CorrectionTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 260,
            height: 65,
            child: Card(
              margin: const EdgeInsets.all(0),
              elevation: 0,
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: StadiumBorder(side: BorderSide(color: grayTranslucent, width: 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: InkWell(
                        splashColor: neon.withAlpha(100),
                        highlightColor: neon.withAlpha(30),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ab",
                                  style: TextStyle(fontSize: 12, color: gray.withAlpha(170)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: neonTranslucent, width: 3)),
                                        //color: neonTranslucent,
                                        //borderRadius: BorderRadius.circular(5)
                                      ),
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text(
                                        widget.correction.ab % Duration.millisecondsPerHour == 0
                                            ? (widget.correction.ab ~/ Duration.millisecondsPerHour).toString()
                                            : (widget.correction.ab / Duration.millisecondsPerHour).toStringAsFixed(2).replaceAll(".", ","),
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20, color: neon),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      "Stunden",
                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18, color: grayAccent),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          int initHour = widget.correction.ab ~/ Duration.millisecondsPerHour;
                          int initMinute = (widget.correction.ab - initHour * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                          final TimeOfDay? newTime = await showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            cancelText: "Abbrechen",
                            confirmText: "Speichern",
                            helpText: "Stunden auswählen",
                            context: context,
                            initialTime: TimeOfDay(hour: initHour, minute: initMinute),
                          );
                          if (newTime != null) {
                            getIt<CorrectionDB>().changeAB(widget.index,
                                newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute, widget.correction);
                          }
                        }),
                  ),
                  Flexible(
                    child: InkWell(
                        splashColor: neon.withAlpha(100),
                        highlightColor: neon.withAlpha(30),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mindestens",
                                  style: TextStyle(fontSize: 12, color: gray.withAlpha(170)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: neonTranslucent, width: 3)),
                                        //color: neonTranslucent,
                                        //borderRadius: BorderRadius.circular(5)
                                      ),
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Text(
                                        (widget.correction.um ~/ Duration.millisecondsPerMinute).toString(),
                                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 20, color: neon),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "Minuten",
                                      style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18, color: grayAccent),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          int initHour = widget.correction.um ~/ Duration.millisecondsPerHour;
                          int initMinute = (widget.correction.um - initHour * Duration.millisecondsPerHour) ~/ Duration.millisecondsPerMinute;
                          final TimeOfDay? newTime = await showTimePicker(
                            cancelText: "Abbrechen",
                            confirmText: "Speichern",
                            helpText: "Minuten auswählen",
                            context: context,
                            initialTime: TimeOfDay(hour: initHour, minute: initMinute),
                          );
                          if (newTime != null) {
                            setState(() {
                              getIt<CorrectionDB>().changeUM(widget.index,
                                  newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute, widget.correction);
                            });
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                widget.closeCallback();
              },
              icon: Icon(Icons.close_rounded))
        ],
      ),
    );
  }
}
