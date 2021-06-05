import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class WochentagePicker extends StatefulWidget {
  WochentagePicker({
    Key? key,
    required
    this.isDay,
  }) : super(key: key);

  final bool isDay;

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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.isDay
                ? neonTranslucent
                : neon.withAlpha(100)),
            child: const Center(
              child: Icon(Icons.today_rounded,color: neonAccent,size: 26.0,),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: neon,
                      width: 2.5
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:3.0),
                      child: Text("Arbeitstage", style: widget.isDay
                          ? settingsTitle
                          : settingsTitle.copyWith(color: Colors.white)),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return FittedBox(
                          fit: BoxFit.fitWidth,
                          child: ToggleButtons(
                            constraints: BoxConstraints(
                              maxHeight: double.infinity,
                              maxWidth: double.infinity,
                              minWidth: constraints.maxWidth/7
                            ),
                            borderColor: Colors.white.withAlpha(100),
                            color: neon.withAlpha(100),
                            selectedColor: neon,
                            fillColor: Colors.transparent,
                            selectedBorderColor: Colors.white,
                            splashColor: Colors.transparent,
                            renderBorder: false,
                            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0, height: 1),
                            disabledColor: Colors.white,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                                  child: Text("MO")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("DI")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("MI")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("DO")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("FR")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("SA")),
                              Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("SO")),
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
                        );
                      }
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );

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
                                color: snapshot.data!.withAlpha(30),
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