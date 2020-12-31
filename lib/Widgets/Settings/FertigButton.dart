import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class FertigButton extends StatelessWidget {
  const FertigButton({
    Key key,
    @required
    this.isDay,
  }) : super(key: key);

  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:20.0),
      child: RaisedButton(
        splashColor: neonTranslucent,
        highlightColor: neonTranslucent.withAlpha(80),
        highlightElevation: 12.0,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0),
        shape: const StadiumBorder(),
        color: neonAccent,
        onPressed: (){
          Navigator.pop(context);
        },
        child: Text("Fertig", style:openButtonText.copyWith(
          color: isDay?Colors.white:darkBackground
        )),
      ),
    );
  }
}