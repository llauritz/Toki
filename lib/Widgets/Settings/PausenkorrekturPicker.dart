import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class PausenkorrekturPicker extends StatefulWidget {
  PausenkorrekturPicker({
    Key key,
  }) : super(key: key);

  @override
  _PausenkorrekturPickerState createState() => _PausenkorrekturPickerState();
}

class _PausenkorrekturPickerState extends State<PausenkorrekturPicker> {
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
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0,0.0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:20.0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: snapshot.data),
                        child: Center(
                          child: Icon(Icons.update_rounded,color: Colors.white,size: 30.0,),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 11.0, 25.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Automatische Pausenkorrektur", style: Theme.of(context).textTheme.headline3),
                                Switch.adaptive(
                                  activeColor: snapshot.data,
                                    activeTrackColor: snapshot.data.withAlpha(100),
                                    value: getIt<Data>().pausenKorrektur,
                                    onChanged:(newValue){
                                      setState(() {
                                        getIt<Data>().updatePausenKorrektur(newValue);
                                        getIt<Data>().pausenKorrektur = newValue;
                                      });
                                    }
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 120,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds){
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment(-0.85, 0),
                                  colors: <Color>[Colors.white.withAlpha(0),Colors.white,],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstATop,
                              child: AnimatedList(
                                scrollDirection: Axis.horizontal,

                                shrinkWrap: true,
                                initialItemCount: getIt<Data>().korrekturAB.length,
                                  itemBuilder: (context, index, animation){
                                    return index != getIt<Data>().korrekturAB.length-1
                                      // Regular Listelement

                                    //TODO: REMOVE PADDING -> INSTEAD switch to get first Widget

                                        ? Padding(
                                          padding: const EdgeInsets.only(left:20.0),
                                          child: KorrekturListItem(listIndex: index, buttonColor: snapshot.data,),
                                        )
                                      // Last Listelement
                                        : Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            KorrekturListItem(listIndex: index,buttonColor: snapshot.data,),
                                            KorrekturAddButton()
                                          ],
                                        );
                                  }
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

class KorrekturListItem extends StatelessWidget {
  const KorrekturListItem({
    Key key,
    @required
    this.listIndex,
    @required
    this.buttonColor
  }) : super(key: key);

  final Color buttonColor;
  final int listIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 3.0),
                child: Text("Ab"),
              ),
              KorrekturTile(
                  buttonColor: buttonColor,
                  value: getIt<Data>().korrekturAB[listIndex],
                  label: "Stunden",
                  callback: (){}),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 0, 0, 3.0),
                child: Text("Mindestens"),
              ),
              KorrekturTile(
                  buttonColor: buttonColor,
                  value: getIt<Data>().korrekturUM[listIndex],
                  label: "Minuten",
                  callback: (){}),
            ],
          ),
        ],
      ),
    );
  }
}

class KorrekturTile extends StatelessWidget {
  const KorrekturTile({
    Key key,
    @required this.buttonColor,
    @required this.value,
    @required this.callback,
    @required this.label,
  }) : super(key: key);

  final Color buttonColor;
  final int value;
  final Function callback;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: RaisedButton(
        splashColor: Colors.white.withAlpha(100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        color: buttonColor,
        onPressed: callback,
        child: Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: Column(
            children: [
              Text(value.toString(), style: TextStyle(color: Colors.white, fontSize: 48)),
              Text(label, style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}

class KorrekturAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      //TODO: Add Function
        icon: Icon(Icons.add_circle_outline, size: 30.0,), onPressed: null)
      ;
  }
}
