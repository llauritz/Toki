import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

import 'OvertimeOffsetRoute.dart';

class OverTimeOffsetPage extends StatelessWidget {
  const OverTimeOffsetPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: neon.withAlpha(80),
      highlightColor: neonTranslucent.withAlpha(150),
      shape: StadiumBorder(),
      height: 100,
        minWidth: 100,
        child: Hero(
        tag:"icon",
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: neonTranslucent,
                  borderRadius: BorderRadius.circular(1000)
              ),
              child: Icon(Icons.more_time, color: neonAccent,)),
        )
    ),
        onPressed: (){
          Navigator.of(context).push(HeroDialogRouteBlur(
              builder: (context){
                return AlertDialog(
                  contentPadding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                    elevation: 3,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag:"icon",
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: neonTranslucent,
                                      borderRadius: BorderRadius.circular(1000)
                                  ),
                                  child: Icon(Icons.more_time, color: neonAccent,)),
                            )
                        ),
                        SizedBox(width: 20,),
                        Text("Zeit hinzufügen", style: headline2.copyWith(color: Colors.blueGrey)),
                      ],
                    ),


                    actions: [
                      FlatButton(
                        onPressed: (){
                          //TODO: Speichern
                          Navigator.of(context).pop();
                        },
                        child: Text("SPEICHERN", style: openButtonText.copyWith(color: gray),)),
                    SizedBox(width: 10,)
                  ],
                );
              }
          ));
        }
    );
  }
}