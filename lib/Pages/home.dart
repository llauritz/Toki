import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:work_in_progress/Widgets/AnimatedStempelButton.dart';
import 'package:work_in_progress/Widgets/SettingsButton.dart';
import 'package:work_in_progress/Widgets/background.dart';
import '../Services/timer.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  PanelController pc = new PanelController();
  TimerText timerText = TimerText();

  @override
  Widget build(BuildContext context) {

  print("home - build start");

    return Scaffold(
      body: SlidingUpPanel(
        minHeight: 240.0,
        maxHeight: 700.0,
        backdropTapClosesPanel: true,
        controller: pc,
        backdropEnabled: true,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
              color: Colors.transparent,
              spreadRadius: 0.0,
              blurRadius: 0.0
          )
        ],

        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedStempelButton(
                callbackTurnOff: timerText.stop,
                callbackTurnOn: timerText.start
            ),
            TestZeitenliste()
          ],
        ),


        body: Background(
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SettingsButton()
                    ],
                  ),
                  timerText,
                  //MantraText()
                ],
              ),
            )
        ),
      ),
    );
  }
}

class TestZeitenliste extends StatelessWidget {
  const TestZeitenliste({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        child: Container(
          child: Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 505.0,
                  maxHeight: 505.0
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return OpenContainer(
                          transitionType: ContainerTransitionType.fadeThrough,
                          transitionDuration: Duration(milliseconds: 600),
                          closedElevation: 0.0,
                          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                          //TODO get roundness of device
                          openShape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                          closedBuilder: (BuildContext context, void Function() action) {
                            return Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(200.0))),
                            height: 100,
                            child: Center(
                                child: Text("Eintrag" + index.toString())),
                          );},
                          openBuilder: (BuildContext context, void Function({Object returnValue}) action) {
                            //TODO Return Settings Page
                            return Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Text("Eintrag" + index.toString()),
                              ),
                            );
                          }
                      );
                    }
                ),
              )
          ),
          decoration: BoxDecoration(
            color: Colors.white,
        ),

      ),
    ),);
  }
}




