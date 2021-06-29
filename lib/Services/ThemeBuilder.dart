import 'package:flutter/material.dart';

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
    super.initState();
  }

  void changeTheme(ThemeMode newMode) {
    setState(() {
      themeMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, themeMode);
  }
}
