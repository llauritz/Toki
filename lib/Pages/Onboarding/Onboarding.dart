import 'package:Timo/Services/Data.dart';
import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'Onboarding1.dart';
import 'Onboarding2.dart';
import 'Onboarding3.dart';
import 'Onboarding4.dart';
import 'Onboarding5.dart';

GetIt getIt = GetIt.instance;

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

  int _index = 1;

  bool _reverse = false;

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage("assets/background/clouds/clouds0.jpg"), context);
    prechacheImages();
    super.didChangeDependencies();
  }

  void prechacheImages() {
    precacheImage(const AssetImage("assets/background/clouds/clouds1.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds2.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds3.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds4.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds5.jpg"), context);
    precacheImage(const AssetImage("assets/background/clouds/clouds6.jpg"), context);
  }

  Widget _button1 = Row(
    key: ValueKey<int>(1),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Los geht's", style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
      SizedBox(width: 3),
      Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
      ),
    ],
  );

  Widget _button2 = Icon(
    Icons.arrow_forward_rounded,
    color: Colors.white,
  );

  Widget _button3 = Row(
    key: ValueKey<int>(3),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Fertig", style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
      SizedBox(width: 3),
      Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    if (_reverse) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _reverse = false;
      });
    }

    final double _expandedWidth = MediaQuery.of(context).size.width - 200;
    Widget _button = _button1; //initial value
    Widget _widget = Onboarding1(); //initial value

    switch (_index) {
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

    switch (_index) {
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
        if (_index > 1) {
          setState(() {
            _reverse = true;
            _index--;
          });
        }
        return true;
      }, //as Future<bool> Function()?,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(image: DecorationImage(image: const AssetImage("assets/background/clouds/clouds0.jpg"), fit: BoxFit.cover)),
            ),
            SafeArea(
              child: AnimatedPadding(
                duration: duration,
                curve: curve,
                padding: EdgeInsets.only(bottom: 120 + _buttonHeight),
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
                padding: const EdgeInsets.symmetric(vertical: 100.0),
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
                      if (_index == 5) {
                        getIt<Data>().setFinishedOnboarding(true);
                        Navigator.of(context).pop();
                      }
                      setState(() {
                        _index++;
                        print("index $_index");
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
