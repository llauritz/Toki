import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0),
      child: Text(
        "Einstellungen",
        style: settingsHeadline.copyWith(color: grayAccent),
      ),
    ));
  }
}
