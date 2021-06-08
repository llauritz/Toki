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
  const CorrectionTile(
      {Key? key, required this.correction, required this.closeCallback, required this.index})
      : super(key: key);
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
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: gray),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ab",
                      style: TextStyle(fontSize: 12, color: gray),
                    ),
                    Row(
                      children: [
                        InkWell(
                          splashColor: neon.withAlpha(100),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: neonTranslucent,
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              (widget.correction.ab /
                                      Duration.millisecondsPerHour)
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontSize: 20, color: neon),
                            ),
                          ),
                          onTap: () async {
                            int initHour = widget.correction.ab ~/
                                Duration.millisecondsPerHour;
                            int initMinute = (widget.correction.ab -
                                    initHour * Duration.millisecondsPerHour) ~/
                                Duration.millisecondsPerMinute;
                            final TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime:
                                  TimeOfDay(hour: initHour, minute: initMinute),
                            );
                            if (newTime != null) {
                              setState(() {
                                getIt<CorrectionDB>().changeAB(
                                    widget.index,
                                    newTime.hour *
                                            Duration.millisecondsPerHour +
                                        newTime.minute *
                                            Duration.millisecondsPerMinute,
                                    widget.correction);
                              });
                            }
                          },
                        ),
                        Text(
                          "Stunden",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mindestens",
                      style: TextStyle(fontSize: 12, color: gray),
                    ),
                    Row(
                      children: [
                        Text((widget.correction.um /
                                Duration.millisecondsPerMinute)
                            .toString()),
                        Text(
                          "Minuten",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
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

class TimePicker extends StatefulWidget {
  const TimePicker({Key? key, required this.correction, required this.index})
      : super(key: key);

  final Correction correction;
  final int index;

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            visualDensity: VisualDensity.compact,
            disabledColor: Colors.transparent,
            onPressed: null,
          ),
          AnimatedFittedTextFieldContainer(
              growDuration: const Duration(milliseconds: 200),
              growCurve: Curves.easeOutQuart,
              shrinkCurve: Curves.ease,
              child: TextField(
                maxLength: 50,
                cursorColor: neonAccent,
                cursorWidth: 3,
                cursorRadius: const Radius.circular(30),
                enableInteractiveSelection: true,
                enableSuggestions: false,
                style: TextStyle(color: neon, fontSize: 28, height: 1),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 3, -3, 3),
                  suffixText: " ",
                  prefixText: " ",
                  counterText: "",
                  disabledBorder: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide:
                          BorderSide(color: neon.withAlpha(30), width: 100)),
                  enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1)),
                      borderSide:
                          BorderSide(color: neon.withAlpha(80), width: 5)),
                  errorBorder: InputBorder.none,
                ),
                onEditingComplete: () {
                  // Liste sortieren
                  setState(() {});
                },
                onChanged: (String str) {
                  // Liste updaten
                  setState(() {});
                },
              )),
        ],
      ),
    );
  }
}
