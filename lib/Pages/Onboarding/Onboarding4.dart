import 'package:Toki/Services/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding4 extends StatefulWidget {
  @override
  _Onboarding4State createState() => _Onboarding4State();
}

class _Onboarding4State extends State<Onboarding4> {
  List<bool> _selections = getIt<Data>().wochentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          """An welchen Tagen""",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        Text(
          """arbeitest du?""",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).backgroundColor,
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: LayoutBuilder(builder: (context, constraints) {
              return FittedBox(
                fit: BoxFit.fitWidth,
                child: ToggleButtons(
                  constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: double.infinity, minWidth: constraints.maxWidth / 7),
                  borderColor: Colors.white.withAlpha(100),
                  color: Theme.of(context).brightness == Brightness.light ? editColor.withAlpha(50) : neon.withAlpha(50),
                  selectedColor: Theme.of(context).brightness == Brightness.light ? editColor : neon,
                  fillColor: Colors.transparent,
                  selectedBorderColor: Colors.white,
                  splashColor: Colors.transparent,
                  renderBorder: false,
                  textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0, height: 0.7),
                  disabledColor: Colors.white,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("MO")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("DI")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("MI")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("DO")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("FR")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("SA")),
                    Padding(padding: EdgeInsets.only(top: 8), child: Text("SO")),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                    });
                    print("dayrow speichern -- Welcome_Screen_4");
                    getIt<Data>().updateWochentage(_selections);
                  },
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
