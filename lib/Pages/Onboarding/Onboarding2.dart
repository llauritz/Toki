import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding2 extends StatefulWidget {
  @override
  _Onboarding2State createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Wie heißt du?",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        AnimatedContainer(
          height: MediaQuery.of(context).viewInsets.bottom > 180 ? 30 : 30,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Material(
            shape: StadiumBorder(),
            elevation: 5.0,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 22.0),
              child: TextField(
                style: TextStyle(fontSize: 16.0, color: editColor),
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: getIt<Data>().username,
                  fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withAlpha(150)),
                ),
                onChanged: (String str) {
                  setState(() {
                    getIt<Data>().updateName(str);
                  });
                },
              ),
            ),
          ),
        ),
        AnimatedContainer(
          height: MediaQuery.of(context).viewInsets.bottom > 180 ? MediaQuery.of(context).viewInsets.bottom - 200 + 30 : 40,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
        ),
      ],
    );
  }
}
