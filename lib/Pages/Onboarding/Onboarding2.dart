import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

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
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          child: Text(
            "Wie heißt du?",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        KeyboardAvoider(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Material(
              shape: StadiumBorder(),
              elevation: 5.0,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25.0),
                child: TextField(
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name',
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.blueGrey[200]),
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
        )
      ],
    );
  }
}
