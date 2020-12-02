import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Pages/SettingsPage.dart';
import '../../Services/Data.dart';

final getIt = GetIt.instance;

class SettingsButton extends StatefulWidget {
  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<Color>(
      stream: getIt<Data>().primaryColorStream.stream,
      initialData: getIt<Data>().primaryColor,
      builder: (context, snapshot) {
        //widget._settingsPage = SettingsPage(primaryColor: snapshot.data,).build(context);
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: Duration(milliseconds: 500),
            closedColor: snapshot.data.withAlpha(0),
            openColor: Colors.transparent,
            closedElevation: 0.0,
            openElevation: 0.0,
            closedShape: CircleBorder(),
            openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
            onClosed: (context){
              setState(() {});
            },
            openBuilder: (BuildContext context, void Function({Object returnValue}) action) {
              return SettingsPage();
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
    );
  }
}
