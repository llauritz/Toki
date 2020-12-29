import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class TimerTextWidget extends StatefulWidget {
  const TimerTextWidget({
    Key key,
    @required this.elapsedTime,
  }) : super(key: key);

  final int elapsedTime;

  @override
  _TimerTextWidgetState createState() => _TimerTextWidgetState();
}

class _TimerTextWidgetState extends State<TimerTextWidget> with TickerProviderStateMixin{

  Duration duration = const Duration(milliseconds: 600);
  Curve curve = Curves.ease;
  GlobalKey zeitRowKey = GlobalKey();
  double containerWidth = 50;
  bool skipCallback = false;

  void updateWidth(){
    //print("sers");
    RenderBox row = zeitRowKey.currentContext.findRenderObject() as RenderBox;
    //print(row.size.width.toString());
    skipCallback=true;
    setState(() {
      containerWidth = MediaQuery.of(context).size.width/2-row.size.width/2;
    });
  }

  @override
  Widget build(BuildContext context) {
    !skipCallback
      ?WidgetsBinding.instance.addPostFrameCallback((_) => updateWidth())
      :skipCallback= false;

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
                AnimatedContainer(duration: duration,
                  width: containerWidth,
                  curve: curve,
                ),
              ],
            ),
            Row(
              key: zeitRowKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('0', style: timerTextNumbers),
                const Text(':',
                    style: timerTextNumbers),
                DoubleDigit(
                    i: elapsedSeconds, style: timerTextNumbers),
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
                AnimatedContainer(duration: duration,
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
                DoubleDigit(
                    i: elapsedMinutes, style: timerTextNumbers),
                const Text(":",
                    style: timerTextNumbers),
                DoubleDigit(
                    i: elapsedSeconds, style: timerTextNumbers),
              ],
            ),
          ],
        ),
      );
    }else if(elapsedHours>0){ // ab 60 Minuten
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
                AnimatedContainer(duration: duration,
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
                Text(elapsedHours.toString(), style: timerTextNumbers),
                const Text(":", style: timerTextNumbers),
                DoubleDigit(i: elapsedMinutes, style: timerTextNumbers),
                const SizedBox(width: 5),
                DoubleDigit(i: elapsedSeconds, style: timerTextNumbers.copyWith(fontSize: 34)),
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
  const DoubleDigit({
    Key key,
    @required this.i,
    @required this.style
  }) : super(key: key);

  final int i;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if(i <= 9){
      return Text('0' + i.toString(), style: style);
    }else{
      return Text(i.toString(), style: style);
    }

  }
}