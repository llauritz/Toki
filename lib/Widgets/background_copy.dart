import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/Data.dart';

final getIt = GetIt.instance;

class Background_legacy extends StatefulWidget {
  const Background_legacy({
    Key? key,
  }) : super(key: key);

  @override
  _Background_legacyState createState() => _Background_legacyState();
}

class _Background_legacyState extends State<Background_legacy> with WidgetsBindingObserver {
  late AssetImage currentImage;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      Future.delayed(Duration(seconds: 2));
      print("background - resumed");
      updateBackground();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("background - init start");
    updateBackground();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    print("background - init finished");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeOutExpo,
      child: KeyedSubtree(
          key: ValueKey<int>(getKeyInt()),
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: currentImage, fit: BoxFit.cover)),
          )),
      duration: const Duration(milliseconds: 3000),
    );
  }

  AssetImage currentBackground() {
    int hourNow = DateTime.now().hour;
    int minuteNow = DateTime.now().minute;

    double currentTime = hourNow + minuteNow / 100;
    // example: 16:35 -> 16.35

    if (currentTime <= 6.59 || currentTime >= 20) {
      // eigentlich clouds 1

      return const AssetImage('assets/background/clouds/clouds1_alt.jpg');
    } else if (currentTime >= 7.00 && currentTime < 8.00) {
      return const AssetImage('assets/background/clouds/clouds2.jpg');
    } else if (currentTime >= 8.00 && currentTime < 11.00) {
      return const AssetImage("assets/background/clouds/clouds3.jpg");
    } else if (currentTime >= 11.00 && currentTime < 15.30) {
      return const AssetImage("assets/background/clouds/clouds4.jpg");
    } else if (currentTime >= 15.30 && currentTime < 17.30) {
      return const AssetImage("assets/background/clouds/clouds2.jpg");
    } else if (currentTime >= 17.30 && currentTime < 20.00) {
      return const AssetImage("assets/background/clouds/clouds6.jpg");
    }
    return const AssetImage("assets/background/clouds/clouds3.jpg");
  }

  void updateBackground() {
    setState(() {
      currentImage = currentBackground();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  int getKeyInt() {
    final int hourNow = DateTime.now().hour;
    final int minuteNow = DateTime.now().minute;

    final double currentTime = hourNow + minuteNow / 100;
    // example: 16:35 -> 16.35

    if (currentTime <= 6.59 || currentTime >= 20) {
      return 1;
    } else if (currentTime >= 7.00 && currentTime < 8.00) {
      return 2;
    } else if (currentTime >= 8.00 && currentTime < 11.00) {
      return 3;
    } else if (currentTime >= 11.00 && currentTime < 15.30) {
      return 4;
    } else if (currentTime >= 15.30 && currentTime < 17.30) {
      return 5;
    } else if (currentTime >= 17.30 && currentTime < 20.00) {
      return 6;
    }
    return 7;
  }
}
