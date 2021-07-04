import 'package:flutter/material.dart';
import 'Data.dart';
import 'Theme.dart';

class ThemeBuilder extends StatefulWidget {
  final Function(BuildContext context, ThemeMode themeMode) builder;
  const ThemeBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeBuilderState>()!;
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  ThemeMode themeMode = ThemeMode.dark;

  @override
  void initState() {
    themeMode = getIt<Data>().getThemeMode();
    super.initState();
  }

  void changeTheme(ThemeMode newMode) async {
    setState(() {
      themeMode = newMode;
    });
    getIt<Data>().setTheme(newMode);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, themeMode);
  }
}
