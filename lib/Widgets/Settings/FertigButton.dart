import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';

class FertigButton extends StatelessWidget {
  const FertigButton({
    Key? key,
    required this.isDay,
  }) : super(key: key);

  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
              onPrimary: neonTranslucent.withAlpha(150),
              //elevation: 5,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              primary: neon,
              shape: const StadiumBorder(),
              shadowColor: Colors.black54)
          .merge(
        ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) return 7.0;
              return 5.0;
            },
          ),
        ),
      ),

      // splashColor: neonTranslucent.withAlpha(150),
      // highlightColor: neonTranslucent.withAlpha(80),
      // highlightElevation: 0,
      // elevation: 0,
      // padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      // shape: const StadiumBorder(),
      // color: neon,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Fertig",
          style: openButtonText.copyWith(
              color: isDay ? Colors.white : darkBackground)),
    );
  }
}
