import 'package:Timo/Widgets/OvertimeChangeWidgetOnboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

GetIt getIt = GetIt.instance;

class Onboarding5 extends StatefulWidget {
  @override
  _Onboarding5State createState() => _Onboarding5State();
}

class _Onboarding5State extends State<Onboarding5> {
  List<bool> _selections = getIt<Data>().wochentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          """Hast du bereits""",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        Text(
          """Überstunden?""",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            child: const OvertimeChangeWidgetOnboarding(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
          child: Text(
            """Du kannst sie auch später noch nachtragen.""",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.normal),
          ),
        ),
        AnimatedContainer(
          height: MediaQuery.of(context).viewInsets.bottom > 180 ? MediaQuery.of(context).viewInsets.bottom - 200 + 50 : 40,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOutQuart,
        ),
      ],
    );
  }
}
