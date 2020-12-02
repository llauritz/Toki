import 'package:flutter/material.dart';

class TimerTextWidget extends StatelessWidget {
  const TimerTextWidget({
    Key key,
    @required this.elapsedTime,
  }) : super(key: key);

  final int elapsedTime;

  @override
  Widget build(BuildContext context) {
    int elapsedSeconds = ((elapsedTime/(1000))%60).truncate();
    int elapsedMinutes = ((elapsedTime/(60*1000))%60).truncate();
    int elapsedHours = ((elapsedTime/(60*60*1000))%60).truncate();
/*    print("timer - elapsed Hours" + elapsedHours.toString());
    print("timer - elapsed Minutes" + elapsedMinutes.toString());
    print("timer - elapsed Seconds" + elapsedSeconds.toString());*/

    if(elapsedMinutes < 1){ //Bis zu 60 Sekunden
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("0", style: Theme.of(context).textTheme.headline1),
          Text(":", style: Theme.of(context).textTheme.headline1),
          DoubleDigit(i: elapsedSeconds, style:Theme.of(context).textTheme.headline1),
        ],
      );
    }else if(elapsedHours < 1){ // 1 Minute bis 60 Minuten
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DoubleDigit(i: elapsedMinutes, style:Theme.of(context).textTheme.headline1),
          Text(":", style: Theme.of(context).textTheme.headline1),
          DoubleDigit(i: elapsedSeconds, style:Theme.of(context).textTheme.headline1),
        ],
      );
    }else if(elapsedHours>0){ // ab 60 Minuten
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(elapsedHours.toString(), style: Theme.of(context).textTheme.headline1),
          Text(":", style: Theme.of(context).textTheme.headline1),
          DoubleDigit(i: elapsedMinutes, style:Theme.of(context).textTheme.headline1),
          SizedBox(width: 5),
          Column(
            children: [
              SizedBox(height: 20),
              DoubleDigit(i: elapsedSeconds, style:Theme.of(context).textTheme.headline2),
              Container(),
            ],
          )
        ],
      );
    }

    return Column(
      children: [
        Text(elapsedMinutes.toString()),
        Text(DateTime.fromMicrosecondsSinceEpoch(elapsedTime).second.toString()),
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
      return Text("0" + i.toString(), style: style);
    }else{
      return Text(i.toString(), style: style);
    }

  }
}