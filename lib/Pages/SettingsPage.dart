import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/AutomaticStop.dart';
import 'package:Timo/Widgets/Settings/PdfExport/ExportPage.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/animatedSprite.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/syncScrollController.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/widgetMask.dart';
import 'package:Timo/Widgets/Settings/ThemeButton.dart';
import 'package:Timo/Widgets/Settings/WorkTimePicker.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:intl/intl.dart';
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

  static _SettingsPageState of(BuildContext context) {
    return context.findAncestorStateOfType<_SettingsPageState>()!;
  }
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  bool isDay = true;
  bool test = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late ScrollController _scrollController;

  Widget? childForeground;
  Widget childBackground = Container();

  BreakCorrection _breakCorrection = BreakCorrection();

  late AssetImage _image;

  @override
  void initState() {
    _scrollController = SyncScrollController();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween<double>(begin: 0.0, end: 34.0).animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          oldTheme = newTheme;
          childBackground = childForeground!;
          childForeground = null;
        });
        _controller.reset();
      }
    });
    _image = AssetImage('assets/sprites/wipe_mask.png');
    if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      oldTheme = lightTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      oldTheme = darkTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      MediaQuery.of(context).platformBrightness == Brightness.light ? oldTheme = lightTheme : oldTheme = darkTheme;
    }
    super.initState();
  }

  ThemeData newTheme = ThemeData();
  ThemeData oldTheme = ThemeData();

  void update() {
    print("update");

    if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      newTheme = lightTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      newTheme = darkTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      MediaQuery.of(context).platformBrightness == Brightness.light ? newTheme = lightTheme : newTheme = darkTheme;
    }

    if (oldTheme != newTheme) {
      setState(() {
        childForeground = Theme(
          data: newTheme,
          child: Scaffold(
            //backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: ListView(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                children: [
                  const SettingsTitle(),
                  ExportPage(),
                  NamePicker(),
                  WorkTimePicker(
                    color: neon,
                    onboarding: false,
                  ),
                  _breakCorrection,
                  AutomaticStop(),
                  SizedBox(
                    height: 80,
                  ),
                ]),
            floatingActionButton: FertigButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        );
        ;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final width = appSize.width;
    final height = appSize.height;

    Widget childBackground = Theme(
      data: oldTheme,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: ListView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            children: [
              FadeIn(delay: 200, fadeChild: const SettingsTitle()),
              FadeIn(delay: 225, fadeChild: ExportPage()),
              //AutoFadeIn(child: NamePicker()),
              FadeIn(delay: 250, fadeChild: NamePicker()),
              FadeIn(
                  delay: 300,
                  fadeChild: WorkTimePicker(
                    color: neon,
                    onboarding: false,
                  )),
              FadeIn(delay: 350, fadeChild: _breakCorrection),
              FadeIn(delay: 400, fadeChild: AutomaticStop()),

              SizedBox(
                height: 80,
              ),
            ]),
        floatingActionButton: FadeIn(delay: 450, fadeChild: FertigButton()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );

    List<Widget> children = <Widget>[
      Container(
        //width: width,
        //height: height,
        child: childBackground,
      ),
    ];

    update();

    if (childForeground != null) {
      children.add(
        // Draw the foreground masked over the background
        WidgetMask(
          maskChild: Container(
            width: width,
            height: height,
            // Draw the transition animation as the mask
            child: AnimatedSprite(
              image: _image,
              frameWidth: 360,
              frameHeight: 720,
              animation: _animation,
            ),
          ),
          child: Container(
            width: width,
            height: height,
            child: childForeground,
          ),
        ),
      );
    }

    print("----------------" + children.first.toString());
    print("----------------" + children.last.toString());

    print("----------------" + children.length.toString());

    return Stack(
      children: children,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
