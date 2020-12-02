import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class TagesstundenPicker extends StatefulWidget {
  TagesstundenPicker({
    Key key,
  }) : super(key: key);

  @override
  _TagesstundenPickerState createState() => _TagesstundenPickerState();
}

class _TagesstundenPickerState extends State<TagesstundenPicker> {

  double _tagesstunden;

  @override
  void initState() {
    // TODO: implement initState
    _tagesstunden = getIt<Data>().tagesstunden;
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
                padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 0),
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
                          child: Icon(Icons.schedule,color: Colors.white,size: 30.0,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tagesstunden", style: Theme.of(context).textTheme.headline3),
                                Text(_tagesstunden.toString()+" Stunden", style: Theme.of(context).textTheme.headline3)
                              ],
                            ),
                          ),
                          Slider.adaptive(
                            value: _tagesstunden,
                            onChanged: (newTagesstunden) {
                              setState(() => _tagesstunden = newTagesstunden);
                            },
                            onChangeEnd: (newTagesstunden) {
                              setState(() {
                                getIt<Data>().updateTagesstunden(newTagesstunden);
                              });
                            },
                            min: 0,
                            max: 12,
                            divisions: 24,
                            activeColor: snapshot.data,
                            inactiveColor: snapshot.data.withOpacity(0.4),
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