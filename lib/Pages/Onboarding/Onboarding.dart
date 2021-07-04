import 'package:Timo/Pages/home.dart';
import 'package:Timo/Services/Data.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/syncScrollController.dart';
import 'package:Timo/Widgets/Settings/ThemeAnimation/widgetMask.dart';
import 'package:Timo/Widgets/Settings/ThemeButton.dart';
import 'package:animations/animations.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:screenshot/screenshot.dart';

import 'Onboarding1.dart';
import 'Onboarding2.dart';
import 'Onboarding3.dart';
import 'Onboarding4.dart';
import 'Onboarding5.dart';

GetIt getIt = GetIt.instance;

class ThemedOnboarding extends StatefulWidget {
  const ThemedOnboarding({Key? key}) : super(key: key);

  @override
  _ThemedOnboardingState createState() => _ThemedOnboardingState();

  static _ThemedOnboardingState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemedOnboardingState>()!;
  }
}

class _ThemedOnboardingState extends State<ThemedOnboarding> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  ScreenshotController _screenshotController = ScreenshotController();
  int index = 1;

  Widget? childForeground;
  Widget childBackground = Container();

  ThemeData newTheme = ThemeData();
  ThemeData oldTheme = ThemeData();

  bool switching = false;
  bool init = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _animation = Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
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
              child: Theme(
                data: oldTheme,
                child: Onboarding(),
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
      childBackground = Theme(data: oldTheme, child: Onboarding());
      childForeground = Theme(data: newTheme, child: Onboarding());
      // setState(() {
      //   print("2");
      // });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      oldTheme = getTheme();
      childBackground = Screenshot(controller: _screenshotController, child: Theme(data: oldTheme, child: Onboarding()));
      init = false;
    }
    final appSize = MediaQuery.of(context).size;
    final width = appSize.width;
    final height = appSize.height;

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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              ThemeButton(
                lightColor: Colors.white,
                darkColor: Colors.white,
                callback: () {
                  getIt<Data>().setUpdatedID(2);
                  setState(() {});
                },
              ),
              if (getIt<Data>().updatedID < 2)
                Positioned(
                  right: 1.5,
                  top: 1.5,
                  child: AvatarGlow(
                    showTwoGlows: false,
                    duration: Duration(milliseconds: 1500),
                    endRadius: 15,
                    child: Container(
                      decoration: BoxDecoration(color: neonAccent, shape: BoxShape.circle),
                      width: 10,
                      height: 10,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ));

    return Material(
      child: Stack(
        children: children,
      ),
    );
  }
}

class Onboarding extends StatefulWidget {
  const Onboarding();

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final double _collapsedWidthHeight = 80;
  final double _expandedHeight = 60;
  final Curve curve = Curves.easeInOutQuart;
  final Duration duration = const Duration(milliseconds: 500);
  double _buttonWidth = 300;
  double _buttonHeight = 60;

  bool _reverse = false;

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage("assets/background/clouds/clouds0.jpg"), context);
    prechacheImages();
    super.didChangeDependencies();
  }

  void prechacheImages() {
    precacheImage(const AssetImage("assets/background/clouds/clouds1_alt.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  @override
  Widget build(BuildContext context) {
    Widget _button1 = Row(
      key: ValueKey<int>(1),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Los geht's", style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
        SizedBox(width: 3),
        Icon(
          Icons.arrow_forward_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );

    Widget _button2 = Icon(
      Icons.arrow_forward_rounded,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    Widget _button3 = Row(
      key: ValueKey<int>(3),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Fertig", style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
        SizedBox(width: 3),
        Icon(
          Icons.arrow_forward_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );

    if (_reverse) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _reverse = false;
      });
    }

    final double _expandedWidth = MediaQuery.of(context).size.width - 200;
    Widget _button = _button1; //initial value
    Widget _widget = Onboarding1(); //initial value

    switch (ThemedOnboarding.of(context).index) {
      case 1:
        {
          _widget = Onboarding1();
          break;
        }
      case 2:
        {
          _widget = Onboarding2();
          break;
        }
      case 3:
        {
          _widget = Onboarding4();
          break;
        }
      case 4:
        {
          _widget = Onboarding3();
          break;
        }
      case 5:
        {
          _widget = Onboarding5();
          break;
        }
      default:
        {
          _widget = Onboarding1();
        }
    }

    switch (ThemedOnboarding.of(context).index) {
      case 1:
        {
          _button = _button1;
          _buttonWidth = _expandedWidth;
          _buttonHeight = _expandedHeight;
          break;
        }
      case 5:
        {
          _button = _button3;
          _buttonWidth = _expandedWidth - 40;
          _buttonHeight = _expandedHeight;
          break;
        }
      default:
        {
          _button = _button2;
          _buttonWidth = _collapsedWidthHeight;
          _buttonHeight = _collapsedWidthHeight;
        }
    }

    return WillPopScope(
      onWillPop: () async {
        if (ThemedOnboarding.of(context).index > 1) {
          setState(() {
            _reverse = true;
            ThemedOnboarding.of(context).index--;
          });
        }
        return false;
      }, //as Future<bool> Function()?,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: (Theme.of(context).brightness == Brightness.light)
                  ? BoxDecoration(image: DecorationImage(image: const AssetImage("assets/background/clouds/clouds0.jpg"), fit: BoxFit.cover))
                  : BoxDecoration(image: DecorationImage(image: const AssetImage("assets/background/clouds/clouds1_alt.jpg"), fit: BoxFit.cover)),
            ),
            SafeArea(
              child: AnimatedPadding(
                duration: duration,
                curve: curve,
                padding: EdgeInsets.only(bottom: 100 + _buttonHeight),
                child: PageTransitionSwitcher(
                  reverse: _reverse,
                  transitionBuilder: (
                    Widget child,
                    Animation<double> primaryAnimation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return SharedAxisTransition(
                      child: child,
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      fillColor: Colors.transparent,
                    );
                  },
                  child: _widget,
                  duration: const Duration(milliseconds: 600),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: ButtonTheme(
                  minWidth: 0,
                  height: 0,
                  child: RaisedButton(
                    splashColor: neonTranslucent.withAlpha(180),
                    highlightColor: neonTranslucent.withAlpha(60),
                    highlightElevation: 10,
                    visualDensity: VisualDensity(vertical: 0.0, horizontal: 0.0),
                    elevation: 5,
                    padding: EdgeInsets.all(0),
                    shape: StadiumBorder(),
                    color: neon,
                    onPressed: () {
                      if (ThemedOnboarding.of(context).index == 5) {
                        getIt<Data>().setFinishedOnboarding(true);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }));
                      }
                      setState(() {
                        ThemedOnboarding.of(context).index++;
                        print("index " + ThemedOnboarding.of(context).index.toString());
                      });
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(0),
                      curve: curve,
                      width: _buttonWidth,
                      height: _buttonHeight,
                      duration: duration,
                      child: PageTransitionSwitcher(
                        transitionBuilder: (
                          Widget child,
                          Animation<double> primaryAnimation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return SharedAxisTransition(
                            child: child,
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.scaled,
                            fillColor: Colors.transparent,
                          );
                        },
                        duration: const Duration(milliseconds: 600),
                        child: _button,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
