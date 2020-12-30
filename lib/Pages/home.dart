import 'dart:async';

import 'package:Timo/Services/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Services/timer.dart';
import '../Widgets/AnimatedStempelButton.dart';
import '../Widgets/OvertimeCardsList.dart';
import '../Widgets/Settings/SettingsButton.dart';
import '../Widgets/background_copy.dart';

final getIt = GetIt.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PanelController pc = PanelController();
  TimerText timerText = TimerText();
  StreamController<Color> containerColorStream = StreamController<Color>();

  void prechacheImages() {
    precacheImage(const AssetImage("assets/background/clouds/clouds1.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  @override
  void didChangeDependencies() {
    prechacheImages();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('home - build start');
    final double bottomInset = MediaQuery.of(context).viewPadding.bottom != 0
                          ? MediaQuery.of(context).viewPadding.bottom
                          : MediaQuery.of(context).systemGestureInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: neon,
      body: SlidingUpPanel(
        //Höhe des Stempelbuttons + Padding + Wie viel von der Karte rausschauen darf
        minHeight: 130 + 20 + 58.0 + bottomInset,
        //Höhe des Stempelbuttons + Padding +Höhe der Karte
        maxHeight: 130 + 20 +MediaQuery.of(context).size.height*0.6 + bottomInset,
        backdropTapClosesPanel: true,
        controller: pc,
        backdropEnabled: true,
        renderPanelSheet: false,
        onPanelSlide: (double value){
          value>0.1
            ? containerColorStream.sink.add(Colors.white.withAlpha(0))
            : containerColorStream.sink.add(Colors.white);
        },
        onPanelClosed: (){
          containerColorStream.sink.add(Colors.white);
        },
        footer: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: SizedBox(
          height: bottomInset,
            width: MediaQuery.of(context).size.width-16,
            child: StreamBuilder<Color>(
              stream: containerColorStream.stream,
              initialData: Colors.white,
              builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: snapshot.data,
                );
              }
            ),
          ),
        ),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.transparent,
              width: double.infinity,
              child: AnimatedStempelButton(
                  callbackTurnOff: timerText.stop,
                  callbackTurnOn: timerText.start),
            ),
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height*0.6,
              child: ZeitenPanel(
                panelController: pc,
                updateTimer: timerText.update,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            const Background_legacy(),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon:
                              const Icon(Icons.refresh_rounded, color: Colors.transparent),
                          onPressed: () {
                            Navigator.pushNamed(context, '/onboarding');
                          }),
                      IconButton(
                          icon:
                              Icon(Icons.bug_report_outlined, color: Colors.white24),
                          onPressed: () {
                            LogConsole.open(context);
                          }),
                      SettingsButton()
                    ],
                  ),
                  const SizedBox(
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
/*    getIt<Data>().dispose();
    getIt<HiveDB>().dispose();*/
    containerColorStream.close();
    print('home - DISPOSING-----------------');
    super.dispose();
  }
}

