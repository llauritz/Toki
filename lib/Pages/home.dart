import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:work_in_progress/Services/HiveDB.dart';
import 'package:work_in_progress/Widgets/ZeitenCard.dart';
import 'package:work_in_progress/Widgets/background_copy.dart';

import '../Services/Data.dart';
import '../Services/timer.dart';
import '../Widgets/AnimatedStempelButton.dart';
import '../Widgets/Settings/SettingsButton.dart';

final getIt = GetIt.instance;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  PanelController pc = new PanelController();
  TimerText timerText = TimerText();

  void prechacheImages() {
    precacheImage(AssetImage("assets/background/clouds/clouds1.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  @override
  void didChangeDependencies() {
    prechacheImages();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("home - build start");
    return Scaffold(
      backgroundColor: Color(0xff0EE796),
      body: SlidingUpPanel(
        minHeight: 240.0,
        maxHeight: 700.0,
        backdropTapClosesPanel: true,
        controller: pc,
        backdropEnabled: true,
        renderPanelSheet: false,
        /*boxShadow: [
          BoxShadow(
              color: Colors.transparent,
              spreadRadius: 0.0,
              blurRadius: 0.0
          )
        ],*/

        panel: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                width: double.infinity,
                child: AnimatedStempelButton(
                    callbackTurnOff: timerText.stop,
                    callbackTurnOn: timerText.start),
              ),
              ZeitenPanel(
                panelController: pc,
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Background_legacy(),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon:
                              Icon(Icons.refresh_rounded, color: Colors.white),
                          onPressed: () {
                            Navigator.pushNamed(context, "/onboarding");
                          }),
                      SettingsButton()
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  timerText,
                  //MantraText()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    getIt<Data>().dispose();
    getIt<HiveDB>().dispose();
    print("home - DISPOSING-----------------");
    super.dispose();
  }
}

