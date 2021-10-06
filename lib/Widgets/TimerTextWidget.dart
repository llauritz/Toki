import 'package:Toki/Services/Theme.dart';
import 'package:flutter/material.dart';

class TimerTextWidget extends StatefulWidget {
  const TimerTextWidget({
    Key? key,
    required this.elapsedTime,
    required this.constrainedWidth,
  }) : super(key: key);

  final int elapsedTime;
  final double constrainedWidth;

  @override
  _TimerTextWidgetState createState() => _TimerTextWidgetState();
}

class _TimerTextWidgetState extends State<TimerTextWidget> with TickerProviderStateMixin {
  Duration duration = const Duration(milliseconds: 600);
  Curve curve = Curves.ease;
  GlobalKey zeitRowKey = GlobalKey();
  double containerWidth = -1;
  bool skipCallback = false;

  void updateWidth() {
    //print("sers");
    RenderBox row = zeitRowKey.currentContext!.findRenderObject() as RenderBox;
    //print(row.size.width.toString());

    if (containerWidth == widget.constrainedWidth / 2 - row.size.width / 2) {
      return;
    }

    if (!skipCallback) {
      setState(() {
        containerWidth = widget.constrainedWidth / 2 - row.size.width / 2;
      });
    }
    skipCallback = true;
  }

  @override
  Widget build(BuildContext context) {
    if (containerWidth == -1) containerWidth = widget.constrainedWidth / 3;

    !skipCallback ? WidgetsBinding.instance!.addPostFrameCallback((_) => updateWidth()) : skipCallback = false;

    final int elapsedSeconds = ((widget.elapsedTime / (1000)) % 60).truncate();
    final int elapsedMinutes = ((widget.elapsedTime / (60 * 1000)) % 60).truncate();
    final int elapsedHours = ((widget.elapsedTime / (60 * 60 * 1000)) % 60).truncate();
/*    print("timer - elapsed Hours" + elapsedHours.toString());
    print("timer - elapsed Minutes" + elapsedMinutes.toString());
    print("timer - elapsed Seconds" + elapsedSeconds.toString());*/

    if (elapsedMinutes < 1 && elapsedHours < 1) {
      //Bis zu 60 Sekunden
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: containerWidth,
                  curve: curve,
                ),
              ],
            ),
            Row(
              key: zeitRowKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('0', style: Theme.of(context).textTheme.headline1!),
                Text(':', style: Theme.of(context).textTheme.headline1!),
                DoubleDigit(i: elapsedSeconds, style: Theme.of(context).textTheme.headline1!),
              ],
            ),
          ],
        ),
      );
    } else if (elapsedHours < 1) {
      // 1 Minute bis 60 Minuten
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: containerWidth,
                  curve: curve,
                ),
              ],
            ),
            Row(
              key: zeitRowKey,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DoubleDigit(i: elapsedMinutes, style: Theme.of(context).textTheme.headline1!),
                Text(":", style: Theme.of(context).textTheme.headline1!),
                DoubleDigit(i: elapsedSeconds, style: Theme.of(context).textTheme.headline1!),
              ],
            ),
          ],
        ),
      );
    } else if (elapsedHours > 0) {
      // ab 60 Minuten
      return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: containerWidth,
                  curve: curve,
                ),
              ],
            ),
            Row(
              key: zeitRowKey,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(elapsedHours.toString(), style: Theme.of(context).textTheme.headline1!),
                Text(":", style: Theme.of(context).textTheme.headline1!),
                DoubleDigit(i: elapsedMinutes, style: Theme.of(context).textTheme.headline1!),
                const SizedBox(width: 5),
                DoubleDigit(i: elapsedSeconds, style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 34)),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Text(elapsedMinutes.toString()),
        Text(DateTime.fromMicrosecondsSinceEpoch(widget.elapsedTime).second.toString()),
      ],
    );
  }
}

class DoubleDigit extends StatelessWidget {
  const DoubleDigit({Key? key, required this.i, required this.style}) : super(key: key);

  final int i;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (i <= 9) {
      return Text('0' + i.toString(), style: style);
    } else {
      return Text(i.toString(), style: style);
    }
  }
}
