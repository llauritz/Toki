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
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
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
        children: [
          Background_legacy(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: ButtonTheme(
                    minWidth: 0,
                    height: 0,
                    child: RaisedButton(
                      visualDensity:
                          VisualDensity(vertical: 0.0, horizontal: 0.0),
                      elevation: 7,
                      padding: EdgeInsets.all(0),
                      shape: StadiumBorder(),
                      color: Colors.greenAccent,
                      onPressed: () {
                        setState(() {
                          _index == 3 ? _index = 1 : _index++;
                          _buttonWidth = _index == 1 ? 300 : 80;
                          _buttonHeight = _index == 1 ? 60 : 80;
                          print("index $_index");
                        });
                        if (_index == 4) {
                          Navigator.pop(context);
                        }
                      },
                      child: AnimatedContainer(
                        padding: EdgeInsets.all(0),
                        curve: Curves.easeInOutQuart,
                        width: _buttonWidth,
                        height: _buttonHeight,
                        duration: Duration(milliseconds: 500),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
