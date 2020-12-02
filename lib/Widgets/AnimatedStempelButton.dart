import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/Data.dart';

final getIt = GetIt.instance;

class AnimatedStempelButton extends StatefulWidget {

  AnimatedStempelButton({@required this.callbackTurnOff, @required this.callbackTurnOn});
  Function callbackTurnOff;
  Function callbackTurnOn;

  @override
  _AnimatedStempelButtonState createState() => _AnimatedStempelButtonState();
}

class _AnimatedStempelButtonState extends State<AnimatedStempelButton> {

  Widget button;

  Widget updateButton(bool running){
    if(running == false){
      return StempelButtonSTART(callback: widget.callbackTurnOn);
    }else{
      return StempelButtonSTOP(callback: widget.callbackTurnOff);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getIt<Data>().isRunningStream.stream,
      initialData: false,
      builder: (context, snapshot){
        //TODO add Error exceptions
        return AnimatedSwitcher(
          transitionBuilder:(Widget child, Animation<double> animation){
            return ScaleTransition(child: child, scale: animation);
          },

          switchInCurve: Curves.ease,
          switchOutCurve: Curves.easeOutExpo,

          child: updateButton(snapshot.data),
          duration: const Duration(milliseconds: 500),
        );
      },
    );
  }
}




class StempelButtonSTOP extends StatelessWidget {

  StempelButtonSTOP({@required this.callback});

  Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 10.0,
        onPressed: callback,
        shape: CircleBorder(),
        color: Colors.redAccent[100],
        child: AvatarGlow(
          showTwoGlows: false,
          repeatPauseDuration: Duration(milliseconds: 500),
          duration: Duration(milliseconds: 1000),
          glowColor: Colors.red[900],
          curve: Curves.ease,
          endRadius: 65.0,
          child: Center(
            child: Text(
              "STOP",
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}




class StempelButtonSTART extends StatelessWidget {

  StempelButtonSTART({@required this.callback});

  Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 10.0,
        onPressed: callback,
        shape: CircleBorder(),
        color: Colors.greenAccent,
        child: SizedBox(
          height: 130.0,
          width: 130.0,
          child: Center(
            child: Text(
              "START",
              style: TextStyle(fontSize: 20.0, color: Colors.white, letterSpacing: 0.5, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
