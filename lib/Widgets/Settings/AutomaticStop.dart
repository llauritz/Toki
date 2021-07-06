import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class AutomaticStop extends StatefulWidget {
  const AutomaticStop({Key? key}) : super(key: key);

  @override
  _AutomaticStopState createState() => _AutomaticStopState();
}

class _AutomaticStopState extends State<AutomaticStop> {
  @override
  Widget build(BuildContext context) {
    Duration uhrzeit = Duration(milliseconds: getIt<Data>().automatischAusstempelnTimeMilli);
    TextStyle style = Theme.of(context).textTheme.headline4!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(offset: Offset(0, 8), blurRadius: 8, color: Colors.black.withAlpha(15))],
              borderRadius: BorderRadius.circular(20)),
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            color: Theme.of(context).cardColor,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              splashColor: neon.withAlpha(50),
              highlightColor: Colors.transparent,
              onTap: () async {
                TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: uhrzeit.inHours, minute: uhrzeit.inMinutes % 60),
                );
                if (newTime != null) {
                  getIt<Data>().setAutomatischAusstempelnTimeMilli(
                      newTime.hour * Duration.millisecondsPerHour + newTime.minute * Duration.millisecondsPerMinute);
                  setState(() {});
                }
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Automatisch um ", style: style),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: neonTranslucent, width: 3), top: BorderSide(color: Colors.transparent, width: 3))),
                              child: Text(
                                uhrzeit.inHours.toString() + ":" + (uhrzeit.inMinutes % 60).toString().padLeft(2, "0"),
                                style: style.copyWith(
                                  color: neon,
                                ),
                              ),
                            ),
                            Text(" ausstempeln.", style: style),
                          ],
                        ),
                        Switch(
                            value: getIt<Data>().automatischAusstempeln,
                            onChanged: (newbool) {
                              getIt<Data>().setAutomatischAusstempeln(newbool);
                              setState(() {});
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
