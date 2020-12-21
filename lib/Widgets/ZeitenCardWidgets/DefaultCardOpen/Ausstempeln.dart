import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:work_in_progress/hiveClasses/Zeitnahme.dart';

import 'DayNightPickerEdit.dart';

final getIt = GetIt.instance;

class Ausstempeln extends StatefulWidget {
  const Ausstempeln({
    Key key,
    @required this.uhrzeitenIndex,
    @required this.uhrzeit,
    @required Zeitnahme zeitnahme,
    @required this.zeitnahmeIndex,
    @required this.closedCardIndex,
  })  : _zeitnahme = zeitnahme,
        super(key: key);

  final DateFormat uhrzeit;
  final Zeitnahme _zeitnahme;
  final int uhrzeitenIndex;
  final int zeitnahmeIndex;
  final int closedCardIndex;

  @override
  _AusstempelnState createState() => _AusstempelnState();
}

class _AusstempelnState extends State<Ausstempeln> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.transparent,
      splashColor: Color(0xffE4FFFB),
      onPressed: () {
        int selectedMilli = widget._zeitnahme.endTimes[widget.uhrzeitenIndex];

        int previousMilli = widget._zeitnahme.startTimes[widget.uhrzeitenIndex];

        int followingMilli = 0;
        if (widget._zeitnahme.startTimes.length - 1 > widget.uhrzeitenIndex) {
          followingMilli =
              widget._zeitnahme.startTimes[widget.uhrzeitenIndex + 1];
        } else {
          followingMilli = DateTime(
                      widget._zeitnahme.day.year,
                      widget._zeitnahme.day.month,
                      widget._zeitnahme.day.day + 1)
                  .millisecondsSinceEpoch -
              1;
        }
        showModal(
            context: context,
            configuration: FadeScaleTransitionConfiguration(
                transitionDuration: Duration(milliseconds: 300),
                reverseTransitionDuration: Duration(milliseconds: 200)),
            builder: (context) {
              return DayNightDialogEdited(
                selectedMilli: selectedMilli,
                previousMilli: previousMilli,
                followingMilli: followingMilli,
                index: widget.uhrzeitenIndex,
                listindex: widget.zeitnahmeIndex,
                isStartTime: false,
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit,
            color: Colors.blueGrey[300],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey[50], shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Text(
                  widget.uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(
                      widget._zeitnahme.endTimes[widget.uhrzeitenIndex])),
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[300]),
                ),
              ),
            ),
          ),
          Text(
            "Ausstempeln",
            style: TextStyle(color: Colors.blueGrey[300]),
          )
        ],
      ),
    );
  }
}
