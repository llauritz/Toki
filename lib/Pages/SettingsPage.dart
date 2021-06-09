import 'package:Timo/Services/Theme.dart';
import 'package:auto_animated/auto_animated.dart';
import '../Widgets/Settings/BreakCorrection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/Settings/FadeIn.dart';
import '../Widgets/Settings/FertigButton.dart';
import '../Widgets/Settings/NamePicker.dart';
import '../Widgets/Settings/PausenkorrekturPicker.dart';
import '../Widgets/Settings/SettingsTitle.dart';
import '../Widgets/Settings/TagesstundenPicker.dart';
import '../Widgets/Settings/WochentagePicker.dart';
import '../Widgets/background.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDay = true;

  @override
  void initState() {
    /*print("SettingsPage - init");
    if (DateTime.now().hour>18 || DateTime.now().hour<8){
      isDay = false;
    }*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(physics: BouncingScrollPhysics(), children: [
          FadeIn(delay: 300 - 100, fadeChild: const SettingsTitle()),
          FadeIn(delay: 350 - 100, fadeChild: NamePicker()),
          FadeIn(delay: 350 - 100, fadeChild: BreakCorrection()),
          FadeIn(
              delay: 400 - 100,
              fadeChild: TagesstundenPicker(
                isDay: isDay,
              )),
          FadeIn(delay: 450 - 100, fadeChild: WochentagePicker(isDay: isDay)),
          FadeIn(
              delay: 500 - 100, fadeChild: PausenkorrekturPicker(isDay: isDay)),
          SizedBox(
            height: 80,
          )
        ]),
      floatingActionButton:
          FadeIn(delay: 350, fadeChild: FertigButton()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
