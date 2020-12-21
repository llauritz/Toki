import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 80.0),
        child: Center(
            child: Text(
              "Einstellungen",
              style: Theme.of(context).textTheme.headline2,
            )
        )
    );
  }
}