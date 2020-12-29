import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class FertigButton extends StatelessWidget {
  const FertigButton({
    Key key,
    @required
    this.callback
  }) : super(key: key);

  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:20.0),
      child: RaisedButton(
        splashColor: Colors.teal,
        highlightColor: Colors.white,
        clipBehavior: Clip.antiAlias,
        focusElevation: 20.0,
        highlightElevation: 12.0,
        elevation: 5.0,
        padding: EdgeInsets.all(0),
        shape: StadiumBorder(),
        color: neonAccent,
        onPressed: callback,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical:20.0, horizontal: 50.0),
          child: Text("Fertig", style:
          openButtonText.copyWith(color: grayDark)),
        ),
      ),
    );
  }
}