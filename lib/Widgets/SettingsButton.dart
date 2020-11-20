import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatefulWidget {
  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: Duration(milliseconds: 500),
        closedColor: Colors.white.withAlpha(0),
        openColor: Colors.white,
        closedElevation: 0.0,
        openElevation: 0.0,
        closedShape: CircleBorder(),
        openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
        onClosed: (context){
          setState(() {});
        },
        openBuilder: (BuildContext context, void Function({Object returnValue}) action) {
          //TODO Return Settings Page
          return Container(

            child: Center(
              child: Text("hi"),
            ),
          );
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return Container(

            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.settings, color: Colors.white),
            ),

          );
        },),
    );
  }
}
