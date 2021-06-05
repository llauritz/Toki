import 'package:Timo/Services/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class PausenkorrekturPicker extends StatefulWidget {
  PausenkorrekturPicker({
    Key? key,
    required this.isDay,
  }) : super(key: key);

  final bool isDay;

  @override
  _PausenkorrekturPickerState createState() => _PausenkorrekturPickerState();
}

class _PausenkorrekturPickerState extends State<PausenkorrekturPicker> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isDay ? neonTranslucent : neon.withAlpha(100)),
            child: const Center(
              child: Icon(
                Icons.update_rounded,
                color: neonAccent,
                size: 26.0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: neon, width: 2.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text("Automatische Pausenkorrektur",
                            style: widget.isDay
                                ? settingsTitle
                                : settingsTitle.copyWith(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Switch(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: neon,
                            activeTrackColor: neon.withAlpha(100),
                            value: getIt<Data>().pausenKorrektur,
                            onChanged: (newValue) {
                              setState(() {
                                getIt<Data>().updatePausenKorrektur(newValue);
                                getIt<Data>().pausenKorrektur = newValue;
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 80,
                    child: AnimatedList(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 16),
                        shrinkWrap: true,
                        initialItemCount: getIt<Data>().korrekturAB.length,
                        itemBuilder: (context, index, animation) {
                          return KorrekturListItem(
                            listIndex: index,
                            buttonColor: neon,
                            isDay: widget.isDay,
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

    // return StreamBuilder<Color>(
    //     stream: getIt<Data>().primaryColorStream.stream,
    //     initialData: getIt<Data>().primaryColor,
    //     builder: (context, snapshot) {
    //       return Padding(
    //         padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
    //         child: Card(
    //           elevation: 10.0,
    //           clipBehavior: Clip.antiAlias,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all(Radius.circular(15.0))),
    //           child: Padding(
    //             padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0),
    //             child: Row(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.symmetric(vertical: 20.0),
    //                   child: AnimatedContainer(
    //                     duration: Duration(milliseconds: 500),
    //                     width: 60.0,
    //                     height: 60.0,
    //                     decoration: BoxDecoration(
    //                         shape: BoxShape.circle, color: snapshot.data),
    //                     child: Center(
    //                       child: Icon(
    //                         Icons.update_rounded,
    //                         color: Colors.white,
    //                         size: 30.0,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Expanded(
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.fromLTRB(
    //                             24.0, 11.0, 25.0, 0.0),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Text("Automatische Pausenkorrektur",
    //                                 style:
    //                                     Theme.of(context).textTheme.headline3),
    //                             Switch.adaptive(
    //                                 activeColor: snapshot.data,
    //                                 activeTrackColor:
    //                                     snapshot.data.withAlpha(100),
    //                                 value: getIt<Data>().pausenKorrektur,
    //                                 onChanged: (newValue) {
    //                                   setState(() {
    //                                     getIt<Data>()
    //                                         .updatePausenKorrektur(newValue);
    //                                     getIt<Data>().pausenKorrektur =
    //                                         newValue;
    //                                   });
    //                                 })
    //                           ],
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 120,
    //                         child: ShaderMask(
    //                           shaderCallback: (Rect bounds) {
    //                             return LinearGradient(
    //                               begin: Alignment.centerLeft,
    //                               end: Alignment(-0.85, 0),
    //                               colors: <Color>[
    //                                 Colors.white.withAlpha(0),
    //                                 Colors.white,
    //                               ],
    //                             ).createShader(bounds);
    //                           },
    //                           blendMode: BlendMode.dstATop,
    //                           child: AnimatedList(
    //                               scrollDirection: Axis.horizontal,
    //                               shrinkWrap: true,
    //                               initialItemCount:
    //                                   getIt<Data>().korrekturAB.length,
    //                               itemBuilder: (context, index, animation) {
    //                                 return index !=
    //                                         getIt<Data>().korrekturAB.length - 1
    //                                     // Regular Listelement

    //                                     //TODO: REMOVE PADDING -> INSTEAD switch to get first Widget

    //                                     ? Padding(
    //                                         padding: const EdgeInsets.only(
    //                                             left: 20.0),
    //                                         child: KorrekturListItem(
    //                                           listIndex: index,
    //                                           buttonColor: snapshot.data,
    //                                         ),
    //                                       )
    //                                     // Last Listelement
    //                                     : Row(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.center,
    //                                         children: [
    //                                           KorrekturListItem(
    //                                             listIndex: index,
    //                                             buttonColor: snapshot.data,
    //                                           ),
    //                                           KorrekturAddButton()
    //                                         ],
    //                                       );
    //                               }),
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }
}

class KorrekturListItem extends StatelessWidget {
  const KorrekturListItem(
      {Key? key,
      required this.listIndex,
      required this.buttonColor,
      required this.isDay})
      : super(key: key);

  final Color buttonColor;
  final int listIndex;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 3.0),
                child: Text(
                  "Ab",
                  style: TextStyle(
                      color: isDay ? gray : Colors.white, fontSize: 12),
                ),
              ),
              KorrekturTile(
                buttonColor: buttonColor,
                value: getIt<Data>().korrekturAB[listIndex],
                label: "Stunden",
                callback: () {},
                isDay: isDay,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 3.0),
                child: Text(
                  "Mindestens",
                  style: TextStyle(
                      color: isDay ? grayAccent : Colors.white, fontSize: 12),
                ),
              ),
              KorrekturTile(
                buttonColor: buttonColor,
                value: getIt<Data>().korrekturUM[listIndex],
                label: "Minuten",
                callback: () {},
                isDay: isDay,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KorrekturTile extends StatelessWidget {
  const KorrekturTile({
    Key? key,
    required this.buttonColor,
    required this.value,
    required this.callback,
    required this.label,
    required this.isDay,
  }) : super(key: key);

  final Color buttonColor;
  final int value;
  final Function callback;
  final String label;
  final bool isDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: RaisedButton(
        elevation: 0,
        splashColor: Colors.white.withAlpha(100),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        color: buttonColor,
        onPressed: callback as void Function()?,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Column(
            children: [
              Text(value.toString(),
                  style: TextStyle(
                      color: isDay ? Colors.white : darkBackground,
                      fontSize: 24)),
              Text(label,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      fontSize: 14,
                      color: isDay ? Colors.white : darkBackground))
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
        icon: Icon(
          Icons.add_circle_outline,
          size: 30.0,
        ),
        onPressed: null);
  }
}
