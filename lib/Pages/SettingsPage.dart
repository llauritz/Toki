
import 'package:Timo/Services/Theme.dart';
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
    Key key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Background backgroundWidget;
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
    return Container(
      color: isDay
        ?Colors.white
        :darkBackground,
      child: Stack(
          children: [
            /*StreamBuilder<Color>(
              stream: getIt<Data>().primaryColorStream.stream,
              initialData: getIt<Data>().primaryColor,
              builder: (context, snapshot) {
                return AnimatedContainer(color: snapshot.data, duration: Duration(milliseconds: 1000),);
              }
            ),*/
            /*Expanded(child: Container(color: Colors.white,)),*/
          /*StreamBuilder<AssetImage>(
              stream: getIt<Data>().currentImageStream.stream,
              initialData: getIt<Data>().currentImage,
              builder: (context, snapshot) {
                return AnimatedContainer(
                  decoration: BoxDecoration(image: DecorationImage(
                      image: snapshot.data, fit: BoxFit.cover
                  )),
                  duration: Duration(milliseconds: 1000),);
              }
            ),*/
          /*Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background/clouds/clouds2.jpg"), fit: BoxFit.cover
                  )
              ),
            ),*/
          /* BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent)),*/
          /*StreamBuilder<String>(
              stream: getIt<Data>().backgroundHashStream.stream,
              initialData: getIt<Data>().backgroundHash,
              builder: (context, snapshot) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 2000),
                  child: KeyedSubtree(
                    key: ValueKey<int>(getIt<Data>().backgroundNumber),
                    child: BlurHash(
                      hash: snapshot.data,
                      imageFit: BoxFit.fill,
                      duration: Duration(microseconds: 1),
                    ),
                  ),
                );
              }),*/
          SafeArea(
            child: Column(
              children: [
                Flexible(
                    flex:2,
                    child: FadeIn(delay: 300-100, fadeChild: const SettingsTitle())),
                FadeIn(delay: 350-100, fadeChild: NamePicker(isDay: isDay,)),
                FadeIn(delay: 400-100, fadeChild: TagesstundenPicker(isDay: isDay,)),
                FadeIn(delay: 450-100, fadeChild: WochentagePicker(isDay: isDay)),
                FadeIn(delay: 500-100, fadeChild: PausenkorrekturPicker(isDay: isDay)),
                Flexible(flex:1,child: Container()),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: FadeIn(
                    delay: 650-100,
                    fadeChild:Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: FertigButton(isDay:isDay),
                    )),
              ),
            ),
          ],

      ),
    );
  }
}