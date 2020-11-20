import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class TestStempelButton extends StatefulWidget {
  @override
  _TestStempelButtonState createState() => _TestStempelButtonState();
}

class _TestStempelButtonState extends State<TestStempelButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StempelButtonOn(),
        StempelButtonOff(),
      ],
    );
  }
}

class StempelButtonOn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){},
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

class StempelButtonOff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){},
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
