import 'package:flutter/material.dart';

import '../TimerTextWidget.dart';

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
    TextStyle _style = Theme.of(context)
        .textTheme
        .headline1
        .copyWith(fontSize: 58, color: _color);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isNegative ? Text("-", style: _style) : Text("", style: _style),
        Text(elapsedHours.toString(), style: _style),
        Text(":", style: _style),
        DoubleDigit(i: elapsedMinutes, style: _style),
      ],
    );
  }
}
