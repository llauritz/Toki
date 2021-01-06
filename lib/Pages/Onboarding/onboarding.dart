import 'package:Timo/Services/Theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Widgets/background_copy.dart';
import 'Onboarding1.dart';
import 'Onboarding2.dart';
import 'Onboarding3.dart';

class Onboarding extends StatefulWidget {
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
  Widget _widget;

  Widget _button1 = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Los geht's",
          style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold)),
      SizedBox(width: 3),
      Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
      ),
    ],
  );

  Widget _button2 = Icon(
    Icons.arrow_forward_rounded,
    color: neonAccent,
  );

  @override
  Widget build(BuildContext context) {

    final double _expandedWidth = MediaQuery.of(context).size.width-200;

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
          _widget = Onboarding3();
          break;
        }
      default:
        {
          _widget = Onboarding1();
        }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Background_legacy(),
          SafeArea(
            child: AnimatedPadding(
              duration: duration,
              curve: curve,
              padding: EdgeInsets.only(bottom: 120+_buttonHeight),
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
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Colors.transparent,
                  );
                },
                child: _widget ?? Onboarding1(),
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
                  splashColor: neon.withAlpha(150),
                  highlightColor: neon.withAlpha(80),
                  highlightElevation: 10,
                  visualDensity:
                      VisualDensity(vertical: 0.0, horizontal: 0.0),
                  elevation: 5,
                  padding: EdgeInsets.all(0),
                  shape: StadiumBorder(),
                  color: neon,
                  onPressed: () {
                    setState(() {
                      _index == 3 ? _index = 1 : _index++;
                      _buttonHeight = _index == 1 ? _expandedHeight : _collapsedWidthHeight;
                      print("index $_index");
                    });
                    if (_index == 4) {
                      Navigator.pop(context);
                    }
                  },
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(0),
                    curve: curve,
                    width: _index == 1 ? _expandedWidth : _collapsedWidthHeight,
                    height: _index == 1 ? _expandedHeight : _collapsedWidthHeight,
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
                      child: _index == 1 ? _button1 : _button2,
                      duration: const Duration(milliseconds: 600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
