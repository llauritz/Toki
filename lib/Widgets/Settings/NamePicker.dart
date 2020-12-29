import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class NamePicker extends StatefulWidget {
  NamePicker({
    Key key,
  }) : super(key: key);

  @override
  _NamePickerState createState() => _NamePickerState();
}

class _NamePickerState extends State<NamePicker> {

  final FocusNode _focusNode = FocusNode();
  Function _button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.cyanAccent,
                    Colors.greenAccent
                  ]
              )
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 20.0,20.0, 20.0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: const Center(
                        child: Icon(Icons.sentiment_satisfied_rounded,color: Colors.cyanAccent,size: 30.0,),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name", style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white)),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: TextFormField(
                                     style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white, fontSize: 24.0),
                                     cursorColor: Colors.white,
                                     cursorRadius: Radius.circular(20),
                                     cursorWidth: 3,
                                     enableSuggestions: true,
                                     initialValue: getIt<Data>().username,
                                     focusNode: _focusNode,
                                     decoration: InputDecoration(

                                       isDense: true,
                                       hintStyle: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white.withAlpha(250), fontSize: 24.0),
                                       contentPadding: EdgeInsets.all(0.0),
                                       enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1),borderSide: BorderSide(color: Colors.white.withAlpha(150), width: 4)),
                                       focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(2)),borderSide: BorderSide(color: Colors.white, width: 5)),

                                     ),

                                     onEditingComplete: (){
                                       setState(() {
                                         _focusNode.unfocus();
                                         _button=null;
                                       });

                                     },

                                      onTap: (){
                                       setState(() {
                                         _button = (){
                                           _focusNode.unfocus();
                                           setState(() {
                                             _button=null;
                                           });
                                         };
                                       });

                                      },

                                     onChanged: (String str){
                                       setState(() {
                                         getIt<Data>().updateName(str);
                                         _button = (){
                                           _focusNode.unfocus();
                                         setState(() {
                                           _button=null;
                                         });
                                         };
                                       });
                                     },
                                    ),
                                  ),
                                ),

                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right:8.0),
                  child: IconButton(
                    icon: Icon(Icons.check),
                    disabledColor: Colors.white.withAlpha(150),
                    onPressed: _button,
                    color: Colors.white,
                    splashRadius: 200,
                    splashColor: Colors.white,

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}