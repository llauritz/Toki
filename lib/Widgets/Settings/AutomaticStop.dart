import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Card(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text("Automatisch um "),
              Text(uhrzeit.inHours.toString() + ":" + (uhrzeit.inMinutes % 60).toString()),
              Text(" ausstempeln."),
              Expanded(child: Container()),
              Switch(value: getIt<Data>().automatischAusstempeln, onChanged: (newbool) {})
            ],
          ),
        ));
  }
}
