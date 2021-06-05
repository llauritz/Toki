import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: const Text(
          "Einstellungen",
          style: settingsHeadline,
        )
    );
  }
}