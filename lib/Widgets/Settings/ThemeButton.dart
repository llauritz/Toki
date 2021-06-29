import 'package:Timo/Services/Theme.dart';
import 'package:Timo/Services/ThemeBuilder.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key}) : super(key: key);

  @override
  _ThemeButtonState createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  Widget _infoText = Container();
  TextStyle style = TextStyle();

  void onPress() async {
    if (ThemeBuilder.of(context).themeMode == ThemeMode.system) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.light);
      _infoText = KeyedSubtree(
          key: ValueKey("light"),
          child: Text(
            "Helles Thema",
            style: style.copyWith(color: grayAccent),
          ));
      setState(() {});
      await Future.delayed(Duration(milliseconds: 2000));
      _infoText = Container();
      setState(() {});
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.light) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.dark);
      _infoText = KeyedSubtree(
          key: ValueKey("dark"),
          child: Text(
            "Dunkles Thema",
            style: style.copyWith(color: gray),
          ));
      setState(() {});
      await Future.delayed(Duration(milliseconds: 2000));
      _infoText = Container();
      setState(() {});
    } else if (ThemeBuilder.of(context).themeMode == ThemeMode.dark) {
      ThemeBuilder.of(context).changeTheme(ThemeMode.system);
      _infoText = KeyedSubtree(
          key: ValueKey("auto"),
          child: Text(
            "Automatisches Thema",
            style: style.copyWith(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : grayAccent),
          ));
      setState(() {});
      await Future.delayed(Duration(milliseconds: 2000));
      _infoText = Container();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
          icon: Icon(
            Icons.brightness_auto_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            onPress();
          },
        ),
      ],
    );
  }
}
