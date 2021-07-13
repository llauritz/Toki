import 'dart:async';

import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/FadeIn.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../Pages/SettingsPage.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key, required this.callback, required this.lightColor, required this.darkColor, required this.fadeDelay}) : super(key: key);

  final Function callback;
  final Color lightColor;
  final Color darkColor;
  final int fadeDelay;

  @override
  _ThemeButtonState createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  Widget _infoText = Container();
  Widget _themeIcon = Container();
  TextStyle style = TextStyle();
  Timer _timer = Timer(Duration(milliseconds: 2000), () {});

  void timer() async {
    _infoText = Container();
    setState(() {});
  }

  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 2000), timer);

    super.initState();
  }

  void onPress(BuildContext c) async {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.light);
      setState(() {});
      _infoText = Container(
        key: ValueKey("light"),
        width: 150,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Helles Thema",
            style: style.copyWith(color: widget.lightColor),
          ),
        ),
      );
      widget.callback();
      _timer.cancel();
      _timer = Timer(Duration(milliseconds: 2000), timer);
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.dark);
      _infoText = Container(
        key: ValueKey("dark"),
        width: 150,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Dunkles Thema",
            style: style.copyWith(color: widget.darkColor),
          ),
        ),
      );
      widget.callback();
      _timer.cancel();
      _timer = Timer(Duration(milliseconds: 2000), timer);
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.system);

      _infoText = Container(
        key: ValueKey("auto"),
        width: 150,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Automatisches Thema",
            style: style.copyWith(color: MediaQuery.of(context).platformBrightness == Brightness.light ? widget.lightColor : widget.darkColor),
          ),
        ),
      );
      widget.callback();
      _timer.cancel();
      _timer = Timer(Duration(milliseconds: 2000), timer);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      _themeIcon = Icon(Icons.brightness_auto_rounded,
          key: ValueKey("_auto"), color: MediaQuery.of(context).platformBrightness == Brightness.light ? widget.lightColor : widget.darkColor);
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      _themeIcon = Icon(
        Icons.light_mode_rounded,
        key: ValueKey("light"),
        color: widget.lightColor,
      );
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      _themeIcon = Icon(
        Icons.dark_mode,
        key: ValueKey("_dark"),
        color: widget.darkColor,
      );
    }

    return FadeIn(
      delay: widget.fadeDelay,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.none,
            height: 45,
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
              child: _infoText,
              duration: const Duration(milliseconds: 600),
            ),
          ),
          IconButton(
              icon: PageTransitionSwitcher(
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
                child: _themeIcon,
                duration: const Duration(milliseconds: 600),
              ),
              onPressed: () => onPress(context)),
        ],
      ),
    );
  }
}
