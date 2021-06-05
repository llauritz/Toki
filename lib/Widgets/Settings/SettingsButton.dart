import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Pages/SettingsPage.dart';
import '../../Services/Data.dart';
import '../../Services/HiveDB.dart';

final getIt = GetIt.instance;

class SettingsButton extends StatefulWidget {
  const SettingsButton();

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
              transitionDuration: const Duration(milliseconds: 500),
              closedColor: Colors.white.withAlpha(0),
              openColor: Colors.white,
              /*closedColor: DateTime.now().hour>18 || DateTime.now().hour<8
                  ?darkBackground.withAlpha(0):Colors.white.withAlpha(0),
              openColor: DateTime.now().hour>18 || DateTime.now().hour<8
                          ?darkBackground:Colors.white,*/
              closedElevation: 0.0,
              openElevation: 0.0,
              closedShape: const CircleBorder(),
              openShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              onClosed: (dynamic context) {
                getIt<HiveDB>().updateGesamtUeberstunden();
              },
              openBuilder: (BuildContext context,
                  void Function({Object? returnValue}) action) {
                return const SettingsPage();
              },
              closedBuilder: (BuildContext context, void Function() action) {
                return Container(
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.settings, color: Colors.white),
                  ),
                );
              },
            ),
          );
        });
  }
}
