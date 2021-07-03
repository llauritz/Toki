import 'dart:async';

import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:Timo/Widgets/Settings/FadeIn.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../Pages/SettingsPage.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key}) : super(key: key);

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
            style: style.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
      SettingsPage.of(context).setState(() {});
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
            style: style.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
      SettingsPage.of(context).setState(() {});
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
            style: style.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
      SettingsPage.of(context).setState(() {});
      setState(() {});
      _timer.cancel();
      _timer = Timer(Duration(milliseconds: 2000), timer);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      _themeIcon = Icon(Icons.brightness_auto_rounded, key: ValueKey("_auto"), color: Theme.of(context).colorScheme.onSurface);
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      _themeIcon = Icon(
        Icons.light_mode_rounded,
        key: ValueKey("light"),
        color: Theme.of(context).colorScheme.onSurface,
      );
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      _themeIcon = Icon(
        Icons.dark_mode,
        key: ValueKey("_dark"),
        color: Theme.of(context).colorScheme.onSurface,
      );
    }

    return FadeIn(
      delay: 100,
      fadeChild: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
