import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 500),
        closedColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
        openColor: Theme.of(context).scaffoldBackgroundColor,
        /*closedColor: DateTime.now().hour>18 || DateTime.now().hour<8
                  ?darkBackground.withAlpha(0):Colors.white.withAlpha(0),
              openColor: DateTime.now().hour>18 || DateTime.now().hour<8
                          ?darkBackground:Colors.white,*/
        closedElevation: 0.0,
        openElevation: 0.0,
        closedShape: const CircleBorder(),
        openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
        onClosed: (dynamic context) {
          getIt<HiveDB>().updateGesamtUeberstunden();
        },
        openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
          getIt<Data>().setUpdatedID(3);
          return const SettingsPage();
        },
        closedBuilder: (BuildContext context, void Function() action) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  if (getIt<Data>().updatedID < 3)
                    Positioned(
                      right: -10,
                      top: -10,
                      child: AvatarGlow(
                        showTwoGlows: false,
                        duration: Duration(milliseconds: 1500),
                        endRadius: 15,
                        child: Container(
                          decoration: BoxDecoration(color: neonAccent, shape: BoxShape.circle),
                          width: 10,
                          height: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
