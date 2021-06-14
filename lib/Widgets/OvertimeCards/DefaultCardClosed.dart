import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../Services/Data.dart';
import '../../Widgets/TimerTextWidget.dart';
import '../../hiveClasses/Zeitnahme.dart';

final getIt = GetIt.instance;

class DefaultCardClosed extends StatefulWidget {
  const DefaultCardClosed({
    required this.i,
    required this.index,
    required this.zeitnahme,
    Key? key,
  }) : super(key: key);

  final int i;
  final int index;
  final Zeitnahme zeitnahme;

  @override
  _DefaultCardClosedState createState() => _DefaultCardClosedState();
}

class _DefaultCardClosedState extends State<DefaultCardClosed> {
  DateFormat fullDate = DateFormat('dd.MM.yyyy');
  DateFormat uhrzeit = DateFormat("H:mm");
  DateFormat wochentag = DateFormat("EE", "de_DE");
  DateFormat datum = DateFormat("dd.MM", "de_DE");
  Color _color = Colors.black;
  Color _colorAccent = Colors.black;
  Color _colorTranslucent = Colors.black;
  static const double _width = 240;

  @override
  Widget build(BuildContext context) {
    final int ueberMilliseconds = widget.zeitnahme.getUeberstunden();
    if (!ueberMilliseconds.isNegative) {
      _color = Colors.tealAccent;
      _colorAccent = Colors.tealAccent[400]!;
      _colorTranslucent = Colors.tealAccent.withAlpha(50);
    } else {
      _color = Colors.blueGrey[300]!;
      _colorAccent = Colors.blueGrey;
      _colorTranslucent = Colors.blueGrey.withAlpha(25);
    }

    if (widget.i >= 0) {
      print("DefaultCardClosed - isRunning " + getIt<Data>().isRunning.toString());
      print("DefaultCardClosed - index " + widget.index.toString());

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: _colorTranslucent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    wochentag.format(widget.zeitnahme.day).substring(0, 2),
                    style: TextStyle(color: _colorAccent, fontSize: 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    datum.format(widget.zeitnahme.day),
                    style: TextStyle(color: _colorAccent, fontSize: 11.0),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Container(
              width: _width,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: _color),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                child: Row(
                  children: [
                    Text(
                      uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(widget.zeitnahme.startTimes[0])),
                      style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0.0),
                      child: Icon(
                        Icons.east_rounded,
                        size: 20.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(uhrzeit.format(DateTime.fromMillisecondsSinceEpoch(widget.zeitnahme.endTimes.last)),
                        style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                    const Expanded(child: Text("")),
                    _Ueberstunden(ueberMilliseconds: ueberMilliseconds)
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
        child: const Text("wtf"),
      );
    }
  }
}

class _Ueberstunden extends StatelessWidget {
  const _Ueberstunden({
    Key? key,
    required int ueberMilliseconds,
  })  : _ueberMilliseconds = ueberMilliseconds,
        super(key: key);

  final int _ueberMilliseconds;

  @override
  Widget build(BuildContext context) {
    final TextStyle greenStyle = Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white);
    final TextStyle blueGreyStyle = Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white);

    //TODO: Test what happens if Zeit == Tagesstunden

    if (_ueberMilliseconds.isNegative) {
      return Container(
        alignment: Alignment.center,
        height: 30.0,
        width: 65.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if ((_ueberMilliseconds / 60000).truncate() != 0)
              Text(
                "-",
                style: blueGreyStyle,
              ),
            Text(Duration(milliseconds: _ueberMilliseconds.abs()).inHours.toString(), style: blueGreyStyle),
            Text(":", style: blueGreyStyle),
            DoubleDigit(i: (_ueberMilliseconds.abs() / Duration.millisecondsPerMinute).truncate() % 60, style: blueGreyStyle)
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey[300],
          borderRadius: BorderRadius.circular(1000),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        height: 30.0,
        width: 65.0,
        decoration: BoxDecoration(
          color: Colors.tealAccent,
          borderRadius: BorderRadius.circular(1000),
        ),
        child: KeyedSubtree(
          key: const ValueKey<int>(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if ((_ueberMilliseconds / 60000).truncate() != 0)
                Text(
                  "+",
                  style: greenStyle,
                ),
              Text(Duration(milliseconds: _ueberMilliseconds).inHours.toString(), style: greenStyle),
              Text(":", style: greenStyle),
              DoubleDigit(i: (_ueberMilliseconds.abs() / Duration.millisecondsPerMinute).truncate() % 60, style: greenStyle)
            ],
          ),
        ),
      );
    }
  }
}
