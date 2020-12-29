import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

import 'TimerTextWidget.dart';

class UeberstundenTextWidget extends StatelessWidget {
  const UeberstundenTextWidget({
    Key key,
    @required this.ueberMilliseconds,
  }) : super(key: key);

  final int ueberMilliseconds;


  @override
  Widget build(BuildContext context) {
    bool isNegative = ueberMilliseconds.isNegative;
    int elapsedMinutes =
    ((ueberMilliseconds.abs() / (60 * 1000)) % 60).truncate();
    int elapsedHours =
    ((ueberMilliseconds.abs() / (60 * 60 * 1000)) % 60).truncate();
/*    print("timer - elapsed Hours" + elapsedHours.toString());
    print("timer - elapsed Minutes" + elapsedMinutes.toString());
    print("timer - elapsed Seconds" + elapsedSeconds.toString());*/

    Color _color = isNegative ? Colors.blueGrey[300] : Colors.tealAccent;
    TextStyle _style = overTimeNumbers.copyWith(color: _color);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNegative) Text("-", style: _style) else Text("", style: _style),
        Text(elapsedHours.toString(), style: _style),
        Text(":", style: _style.copyWith(fontFamily: "BandeinsSans")),
        DoubleDigit(i: elapsedMinutes, style: _style),
      ],
    );
  }
}