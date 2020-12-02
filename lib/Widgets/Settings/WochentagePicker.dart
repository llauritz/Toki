import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class WochentagePicker extends StatefulWidget {
  WochentagePicker({
    Key key,
  }) : super(key: key);

  @override
  _WochentagePickerState createState() => _WochentagePickerState();
}

class _WochentagePickerState extends State<WochentagePicker> {

  List<bool> _selections = getIt<Data>().wochentage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Color>(
        stream: getIt<Data>().primaryColorStream.stream,
        initialData: getIt<Data>().primaryColor,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0,0, 0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:20.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: snapshot.data),
                        child: Center(
                          child: Icon(Icons.today_rounded,color: Colors.white,size: 30.0,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text("Arbeitstage", style: Theme.of(context).textTheme.headline3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:3.0),
                            child: Transform.scale(
                              scale: 0.915,
                              child: ToggleButtons(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderColor: Colors.white.withAlpha(100),
                                color: snapshot.data.withAlpha(30),
                                selectedColor: snapshot.data,
                                fillColor: Colors.transparent,
                                selectedBorderColor: Colors.white,
                                splashColor: Colors.white.withAlpha(100),
                                renderBorder: false,
                                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                disabledColor: Colors.white,
                                  children: <Widget>[
                                    Text("MO"),
                                    Text("DI"),
                                    Text("MI"),
                                    Text("DO"),
                                    Text("FR"),
                                    Text("SA"),
                                    Text("SO")
                                  ],
                                  isSelected: _selections,
                                onPressed: (int index){
                                  setState(() {
                                    _selections[index] = !_selections[index];
                                  });
                                  print("dayrow speichern -- Welcome_Screen_4");
                                  getIt<Data>().updateWochentage(_selections);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}