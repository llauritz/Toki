
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Services/Data.dart';
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
  SettingsPage({
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
    print("SettingsPage - init");
    if (DateTime.now().hour>18 || DateTime.now().hour<8){
      isDay = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder<Color>(
            stream: getIt<Data>().primaryColorStream.stream,
            initialData: getIt<Data>().primaryColor,
            builder: (context, snapshot) {
              return AnimatedContainer(color: snapshot.data, duration: Duration(milliseconds: 1000),);
            }
          ),
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
          child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              FadeIn(delay: 300, fadeChild: SettingsTitle()),
              FadeIn(delay: 350, fadeChild: NamePicker()),
              FadeIn(delay: 400, fadeChild: TagesstundenPicker()),
              FadeIn(delay: 450, fadeChild: WochentagePicker()),
              FadeIn(delay: 500, fadeChild:PausenkorrekturPicker()),

              ],
            ),
          ),
          ),
          SafeArea(
            child: FadeIn(
                delay: 550,
                fadeChild:Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: FertigButton(callback: (){Navigator.pop(context);},),
                )),
          ),
        ],

    );
  }
}