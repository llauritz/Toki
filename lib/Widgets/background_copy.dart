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

class _Background_legacyState extends State<Background_legacy>
    with WidgetsBindingObserver {
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
            decoration: BoxDecoration(
                image: DecorationImage(image: currentImage, fit: BoxFit.cover)),
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
      getIt<Data>().updateSettingsBackground(
          r"+36uL#E100_39F%h%MDi00s:_NIUxGDiRi?c^+Rj9ExuIV%Ms:9FX8j[%NWBRPWVkCxv");
      return const AssetImage('assets/background/clouds/clouds1_alt.jpg');
    } else if (currentTime >= 7.00 && currentTime < 8.00) {
      getIt<Data>().updateSettingsBackground(
          r'+MLxSt9ZELNb%2EM$%WC0ft8t7sn}sR*IpxZtRr?s.s:wJt6ofR*IoShR,s.j[WBbHs:');
      return const AssetImage('assets/background/clouds/clouds2.jpg');
    } else if (currentTime >= 8.00 && currentTime < 11.00) {
      getIt<Data>().updateSettingsBackground(
          r"+6K1tO00T0Ek03-5XTIo005V}=nOS50hM{%1^I^h0hxt~Ax[skEO5Xt6s,jbg4RkxD%1");
      return const AssetImage("assets/background/clouds/clouds3.jpg");
    } else if (currentTime >= 11.00 && currentTime < 15.30) {
      getIt<Data>().updateSettingsBackground(
          r"+CBYFl?a9LNM9Ht7ofWE06Rm?Wxrb0M~WCxr~ks,9KM~Rpxrs.IX9KRl-mt5tRM~Rl%J");
      return const AssetImage("assets/background/clouds/clouds4.jpg");
    } else if (currentTime >= 15.30 && currentTime < 17.30) {
      getIt<Data>().updateSettingsBackground(
          // eigentlich 5
          r"+GHx1=cX~B9a0201V@oevf~A9uxt=x%MxFNHWU4:ofsotSV@ozV[EN-ojFW;EN%LNGof");
      return const AssetImage("assets/background/clouds/clouds2.jpg");
    } else if (currentTime >= 17.30 && currentTime < 20.00) {
      getIt<Data>().updateSettingsBackground(
          r"+BDtSjOG0}E$w}R%n~WU0wWU}Y$jt8S4S3a}J5n$$jNuS5xGoLW=w^WUS3snWUWVs:so");
      return const AssetImage("assets/background/clouds/clouds6.jpg");
    }
    return const AssetImage("assets/background/clouds/clouds3.jpg");
  }

  void updateBackground() {
    getIt<Data>().backgroundNumber = getKeyInt();
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
