import 'dart:async';
import 'dart:ui';

import 'package:Timo/Services/CorrectionDB.dart';
import 'package:Timo/Services/Data.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../Widgets/AnimatedStempelButton.dart';
import '../Widgets/OvertimeCardsList.dart';
import '../Widgets/Settings/SettingsButton.dart';
import '../Widgets/background_copy.dart';

final getIt = GetIt.instance;

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PanelController pc = PanelController();
  StreamController<Color> containerColorStream = StreamController<Color>();
  StreamController<double> blurValueStream = StreamController<double>();
  double _cardPosition = 0;
  double bottomInset = -1;

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
/*    if(!getIt<Data>().finishedOnboarding)
        Navigator.pushNamed(context, "/onboarding");*/

    logger.d('home - build start');

    logger.i("viewPadding + " + MediaQuery.of(context).viewPadding.bottom.toString());
    logger.i("viewInsets + " + MediaQuery.of(context).viewInsets.bottom.toString());
    logger.i("windowPadding + " + MediaQuery.of(context).padding.bottom.toString());
    logger.i("systemGestureInsets + " + MediaQuery.of(context).systemGestureInsets.bottom.toString());

    // is set only once
    if (bottomInset == -1) {
      bottomInset = MediaQuery.of(context).viewInsets.bottom > MediaQuery.of(context).viewPadding.bottom
          ? MediaQuery.of(context).viewInsets.bottom
          : MediaQuery.of(context).viewPadding.bottom;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body:
            //MediaQuery.of(context).size.width <= 1000            ?
            SlidingUpPanel(
          //Höhe des Stempelbuttons + Padding + Wie viel von der Karte rausschauen darf
          minHeight: 130 + 20 + 58.0 + bottomInset,
          //Höhe des Stempelbuttons + Padding +Höhe der Karte
          maxHeight: 130 + 20 + MediaQuery.of(context).size.height * 0.6 + bottomInset,
          backdropTapClosesPanel: true,
          controller: pc,
          backdropEnabled: true,
          renderPanelSheet: false,
          onPanelSlide: (double value) {
            if (value > 0.1 && _cardPosition <= 0.1) {
              containerColorStream.sink.add(Colors.white.withAlpha(0));
              _cardPosition = value;
              logger.v(_cardPosition);
            } else if (value < 0.1 && _cardPosition <= 0.11) {
              containerColorStream.sink.add(Colors.white);
              _cardPosition = value;
              logger.v(_cardPosition);
            } else {
              _cardPosition = value;
            }
            blurValueStream.sink.add((8 * value) + 0.001);
          },
          onPanelClosed: () {
            containerColorStream.sink.add(Colors.white);
          },
          footer: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: bottomInset,
              width: MediaQuery.of(context).size.width - 16,
              child: StreamBuilder<Color>(
                  stream: containerColorStream.stream,
                  initialData: Colors.white,
                  builder: (BuildContext context, AsyncSnapshot<Color> snapshot) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: snapshot.data,
                    );
                  }),
            ),
          ),
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent,
                width: double.infinity,
                child: AnimatedStempelButton(callbackTurnOff: () {
                  getIt<Data>().timerText.stop();
                }, callbackTurnOn: () {
                  getIt<Data>().timerText.start();
                }),
              ),
              //if (MediaQuery.of(context).size.width <= 1000)
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: ZeitenPanel(
                    panelController: pc,
                    updateTimer: () {
                      getIt<Data>().timerText.update();
                    },
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              StreamBuilder<double>(
                stream: blurValueStream.stream,
                initialData: 0.001,
                builder: (context, snapshot) {
                  logger.v(snapshot.data);
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: snapshot.data!, sigmaY: snapshot.data!),
                    child: const HomeContent(),
                  );
                },
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    containerColorStream.close();
    blurValueStream.close();
    print('home - DISPOSING-----------------');
    super.dispose();
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Background_legacy(),
        SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   onPressed: () {
                //     Navigator.of(context).pushNamed("/onboarding");
                //   },
                //   icon: Icon(Icons.bug_report),
                //   color: Colors.red,
                // ),
                // IconButton(
                //   onPressed: () {
                //     getIt<CorrectionDB>().resetBox();
                //   },
                //   icon: Icon(Icons.bug_report),
                //   color: Colors.blue,
                // ),
                const SettingsButton()
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            getIt<Data>().timerText,
            //MantraText()
          ],
        ))
      ],
    );
  }
}
