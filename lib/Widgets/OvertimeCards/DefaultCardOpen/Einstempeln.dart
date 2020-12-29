import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../Services/Data.dart';
import '../../../hiveClasses/Zeitnahme.dart';
import 'DayNightPickerEdit.dart';
import 'DottedLine.dart';

final getIt = GetIt.instance;

class Einstempeln extends StatefulWidget {
  const Einstempeln({
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
  _EinstempelnState createState() => _EinstempelnState();
}

class _EinstempelnState extends State<Einstempeln> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.transparent,
      splashColor: neonTranslucent,
      onPressed: () {
        final int selectedMilli = widget._zeitnahme.startTimes[widget.uhrzeitenIndex];

        int previousMilli = 0;
        if (widget.uhrzeitenIndex != 0) {
          previousMilli = widget._zeitnahme.endTimes[widget.uhrzeitenIndex - 1];
        } else {
          previousMilli = DateTime(widget._zeitnahme.day.year,
                  widget._zeitnahme.day.month, widget._zeitnahme.day.day)
              .millisecondsSinceEpoch;
        }

        int followingMilli = 0;
        if (widget._zeitnahme.endTimes.length > widget.uhrzeitenIndex) {
          followingMilli = widget._zeitnahme.endTimes[widget.uhrzeitenIndex];
        } else if (widget.closedCardIndex == 0 &&
            getIt<Data>().isRunning &&
            widget.uhrzeitenIndex == widget._zeitnahme.startTimes.length - 1) {
          followingMilli = DateTime.now().millisecondsSinceEpoch;
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
            configuration: const FadeScaleTransitionConfiguration(
                transitionDuration: Duration(milliseconds: 300),
                reverseTransitionDuration: Duration(milliseconds: 200)),
            builder: (context) {
              return DayNightDialogEdited(
                selectedMilli: selectedMilli,
                previousMilli: previousMilli,
                followingMilli: followingMilli,
                index: widget.uhrzeitenIndex,
                listindex: widget.zeitnahmeIndex,
                isStartTime: true,
              );
            });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Icon(
              Icons.edit,
              color: Colors.blueGrey[300],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: neonTranslucent, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Center(
                      child: Text(
                        widget.uhrzeit.format(
                            DateTime.fromMillisecondsSinceEpoch(widget
                                ._zeitnahme.startTimes[widget.uhrzeitenIndex])),
                        style:
                            const TextStyle(fontSize: 18, color: Color(0xff00FFDC)),
                      ),
                    ),
                  ),
                ),
              ),
              const DottedLine(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Container(
              width: 120,
              child: Text(
                'Einstempeln',
                style: headline3.copyWith(color: gray),
              ),
            ),
          )
        ],
      ),
    );
  }
}
