import 'dart:ui';

import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/AutomaticStop.dart';
import 'package:Timo/Widgets/Settings/PdfExport/ExportPageButton.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/syncScrollController.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/widgetMask.dart';
import 'package:Timo/Widgets/Settings/ThemeButton.dart';
import 'package:Timo/Widgets/Settings/WorkTimePicker.dart';
import 'package:screenshot/screenshot.dart';
import '../Widgets/Settings/BreakCorrection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/Settings/FadeIn.dart';
import '../Widgets/Settings/FertigButton.dart';
import '../Widgets/Settings/NamePicker.dart';
import '../Widgets/Settings/SettingsTitle.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();

  // static _SettingsPageState of(BuildContext context) {
  //   return context.findAncestorStateOfType<_SettingsPageState>()!;
  // }
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  ScreenshotController _screenshotController = ScreenshotController();
  ScrollController _scrollController = SyncScrollController();

  Widget? childForeground;
  Widget childBackground = Container();

  late AssetImage _image;

  ThemeData newTheme = ThemeData();
  ThemeData oldTheme = ThemeData();

  bool switching = false;
  bool init = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          oldTheme = newTheme;
          childForeground = null;
          childBackground = Screenshot(
              controller: _screenshotController,
              child: ThemedSettingsNoFade(
                theme: oldTheme,
                context: context,
                sc: _scrollController,
              ));
        });
        _controller.reset();
        switching = false;
      }
    });
  }

  ThemeData getTheme() {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      return lightTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      return darkTheme;
    } else {
      return MediaQuery.of(context).platformBrightness == Brightness.light ? newTheme = lightTheme : newTheme = darkTheme;
    }
  }

  void update() async {
    print("update");

    newTheme = getTheme();

    // print(oldTheme.brightness);
    // print(newTheme.brightness);

    if (oldTheme.brightness != newTheme.brightness) {
      switching = true;
      await _screenshotController.capture().then((capturedImage) async {
        print("here");
        ImageProvider mImage = MemoryImage(capturedImage!);
        await precacheImage(mImage, context);
        childBackground = Image(
          image: mImage,
          gaplessPlayback: true,
        );
        childForeground = ThemedSettingsNoFade(
          theme: newTheme,
          context: context,
          sc: _scrollController,
        );
        // setState(() {
        //   print("2");
        // });
        _controller.forward();
      }).catchError((error) {
        print("$error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      oldTheme = getTheme();
      childBackground = Screenshot(
          controller: _screenshotController,
          child: ThemedSettings(
            theme: oldTheme,
            context: context,
            sc: _scrollController,
          ));
      init = false;
    }

    final appSize = MediaQuery.of(context).size;
    final width = appSize.width;
    final height = appSize.height;

    // print(childBackground.toStringDeep());
    // print(childForeground?.toStringDeep());

    if (!switching) update();

    List<Widget> children = <Widget>[
      Container(
        width: width,
        height: height,
        child: childBackground,
      ),
    ];

    if (childForeground != null) {
      children.add(
        // Draw the foreground masked over the background
        WidgetMask(
          maskChild: Positioned(
            top: MediaQuery.of(context).padding.top + 33 - ((height + width) * 0.8) * _animation.value,
            right: 33 - ((height + width) * 0.8) * _animation.value,
            child: Container(
              width: ((height + width) * 0.8) * _animation.value * 2,
              height: ((height + width) * 0.8) * _animation.value * 2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10 + 200 * _animation.value)]),
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

    children.add(Column(
      children: [
        IgnorePointer(
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ThemeButton(
                fadeDelay: 100,
                lightColor: grayAccent,
                darkColor: Colors.blueGrey[100]!,
                callback: () {
                  setState(() {});
                },
              ),
            )),
      ],
    ));

    // print("----------------" + children.first.toString());
    // print("----------------" + children.last.toString());

    // print("----------------" + children.length.toString());

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

class ThemedSettings extends StatelessWidget {
  const ThemedSettings({Key? key, required this.theme, required this.context, required this.sc}) : super(key: key);

  final ThemeData theme;
  final BuildContext context;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body:
            ListView(controller: sc, padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), physics: BouncingScrollPhysics(), children: [
          FadeIn(delay: 200, child: const SettingsTitle()),
          //FadeIn(delay: 225, child: ExportPageButton()),
          FadeIn(delay: 250, child: NamePicker()),
          FadeIn(
              delay: 300,
              child: WorkTimePicker(
                color: neon,
                onboarding: false,
              )),
          FadeIn(delay: 350, child: BreakCorrection()),
          FadeIn(delay: 400, child: AutomaticStop()),
          SizedBox(
            height: 80 + MediaQuery.of(context).padding.bottom,
          ),
        ]),
        floatingActionButton: FadeIn(delay: 450, child: FertigButton()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class ThemedSettingsNoFade extends StatelessWidget {
  const ThemedSettingsNoFade({Key? key, required this.theme, required this.context, required this.sc}) : super(key: key);

  final ThemeData theme;
  final BuildContext context;
  final ScrollController sc;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body:
            ListView(controller: sc, padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), physics: BouncingScrollPhysics(), children: [
          const SettingsTitle(),
          //ExportPageButton(),
          NamePicker(),
          WorkTimePicker(
            color: neon,
            onboarding: false,
          ),
          BreakCorrection(),
          AutomaticStop(),
          SizedBox(
            height: 80 + MediaQuery.of(context).padding.bottom,
          ),
        ]),
        floatingActionButton: FertigButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}


/* import 'dart:typed_data';
import 'dart:ui';

import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/AutomaticStop.dart';
import 'package:Timo/Widgets/Settings/PdfExport/ExportPage.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/syncScrollController.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/widgetMask.dart';
import 'package:Timo/Widgets/Settings/ThemeButton.dart';
import 'package:Timo/Widgets/Settings/WorkTimePicker.dart';
import 'package:screenshot/screenshot.dart';
import '../Widgets/Settings/BreakCorrection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/Settings/FadeIn.dart';
import '../Widgets/Settings/FertigButton.dart';
import '../Widgets/Settings/NamePicker.dart';
import '../Widgets/Settings/SettingsTitle.dart';

final getIt = GetIt.instance;

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();

  // static _SettingsPageState of(BuildContext context) {
  //   return context.findAncestorStateOfType<_SettingsPageState>()!;
  // }
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  ScreenshotController _screenshotController = ScreenshotController();
  ScrollController _scrollController = SyncScrollController();

  Widget? childForeground;
  Widget childBackground = Container();

  ImageProvider bImage = MemoryImage(Uint8List(0));

  ThemeData newTheme = ThemeData();
  ThemeData oldTheme = ThemeData();

  bool switching = false;
  bool capturing = false;
  bool init = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    _animation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.08),
          weight: 5,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.08, end: 1.0),
          weight: 95,
        ),
      ],
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          oldTheme = newTheme;
          childForeground = null;
          childBackground = Screenshot(
              controller: _screenshotController,
              child: ThemedSettingsNoFade(
                theme: oldTheme,
                context: context,
                sc: _scrollController,
              ));
        });
        _controller.reset();
        switching = false;
      }
    });
  }

  ThemeData getTheme() {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      return lightTheme;
    }
    if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      return darkTheme;
    } else {
      return MediaQuery.of(context).platformBrightness == Brightness.light ? newTheme = lightTheme : newTheme = darkTheme;
    }
  }

  void update() async {
    print("update");

    newTheme = getTheme();

    // print(oldTheme.brightness);
    // print(newTheme.brightness);

    while (capturing) {
      print("waiting");
      await Future.delayed(Duration(milliseconds: 30));
    }

    if (oldTheme.brightness != newTheme.brightness) {
      switching = true;
      childBackground = Image(
        image: bImage,
        gaplessPlayback: true,
      );
      childForeground = ThemedSettingsNoFade(
        theme: newTheme,
        context: context,
        sc: _scrollController,
      );
      _controller.forward();
    }
  }

  Future<void> afterBuild() async {
    await Future.delayed(Duration(milliseconds: 800));
    print("capture start");
    _screenshotController.capture(delay: Duration(milliseconds: 50)).then((capturedImage) async {
      print("here");
      bImage = MemoryImage(capturedImage!);
      await precacheImage(bImage, context);
      capturing = false;
    }).catchError((error) {
      print("$error");
      capturing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      oldTheme = getTheme();
      childBackground = Screenshot(
          controller: _screenshotController,
          child: ThemedSettings(
            theme: oldTheme,
            context: context,
            sc: _scrollController,
          ));

      init = false;
    }

    if (!capturing) {
      capturing = true;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        afterBuild();
      });
    }

    final appSize = MediaQuery.of(context).size;
    final width = appSize.width;
    final height = appSize.height;

    // print(childBackground.toStringDeep());
    // print(childForeground?.toStringDeep());

    if (!switching) update();

    List<Widget> children = <Widget>[
      Container(
        width: width,
        height: height,
        child: childBackground,
      ),
    ];

    if (childForeground != null) {
      children.add(
        // Draw the foreground masked over the background
        WidgetMask(
          maskChild: Positioned(
            top: MediaQuery.of(context).padding.top + 33 - ((height + width) * 0.8) * _animation.value,
            right: 33 - ((height + width) * 0.8) * _animation.value,
            child: Container(
              width: ((height + width) * 0.8) * _animation.value * 2,
              height: ((height + width) * 0.8) * _animation.value * 2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10 + 200 * _animation.value)]),
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

    children.add(Column(
      children: [
        IgnorePointer(
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ThemeButton(
                lightColor: grayAccent,
                darkColor: Colors.blueGrey[100]!,
                callback: () {
                  setState(() {});
                },
              ),
            )),
      ],
    ));

    // print("----------------" + children.first.toString());
    // print("----------------" + children.last.toString());

    // print("----------------" + children.length.toString());

    return Listener(
      onPointerUp: (_) {
        print("u");
        afterBuild();
      },
      child: Stack(
        children: children,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ThemedSettings extends StatelessWidget {
  const ThemedSettings({Key? key, required this.theme, required this.context, required this.sc}) : super(key: key);

  final ThemeData theme;
  final BuildContext context;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body:
            ListView(controller: sc, padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), physics: BouncingScrollPhysics(), children: [
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
          FadeIn(delay: 350, fadeChild: BreakCorrection()),
          FadeIn(delay: 400, fadeChild: AutomaticStop()),

          SizedBox(
            height: 80,
          ),
        ]),
        floatingActionButton: FadeIn(delay: 450, fadeChild: FertigButton()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class ThemedSettingsNoFade extends StatelessWidget {
  const ThemedSettingsNoFade({Key? key, required this.theme, required this.context, required this.sc}) : super(key: key);

  final ThemeData theme;
  final BuildContext context;
  final ScrollController sc;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body:
            ListView(controller: sc, padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), physics: BouncingScrollPhysics(), children: [
          const SettingsTitle(),
          ExportPage(),
          //AutoFadeIn(child: NamePicker()),
          NamePicker(),
          WorkTimePicker(
            color: neon,
            onboarding: false,
          ),
          BreakCorrection(),
          AutomaticStop(),

          SizedBox(
            height: 80,
          ),
        ]),
        floatingActionButton: FertigButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
} */
