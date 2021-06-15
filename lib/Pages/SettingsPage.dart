import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Widgets/Settings/WorkTimePicker.dart';
import 'package:auto_animated/auto_animated.dart';
import '../Widgets/Settings/BreakCorrection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/Settings/FadeIn.dart';
import '../Widgets/Settings/FertigButton.dart';
import '../Widgets/Settings/NamePicker.dart';
import '../Widgets/Settings/SettingsTitle.dart';
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
      body: AnimateIfVisibleWrapper(
        child: ListView(physics: BouncingScrollPhysics(), children: [
          FadeIn(delay: 300 - 100, fadeChild: const SettingsTitle()),
          //AutoFadeIn(child: NamePicker()),
          FadeIn(delay: 350 - 100, fadeChild: NamePicker()),
          FadeIn(
              delay: 400 - 100,
              fadeChild: WorkTimePicker(
                color: neon,
                onboarding: false,
              )),
          FadeIn(delay: 400 - 100, fadeChild: BreakCorrection()),

          SizedBox(
            height: 80,
          )
        ]),
      ),
      floatingActionButton: FadeIn(delay: 350, fadeChild: FertigButton()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AutoFadeIn extends StatelessWidget {
  const AutoFadeIn({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimateIfVisible(
        key: UniqueKey(),
        builder: (context, animation) {
          return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
              // And slide transition
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
                // Paste you Widget
                child: child,
              ));
        });
  }
}
