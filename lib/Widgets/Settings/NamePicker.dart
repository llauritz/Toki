import 'package:Timo/Services/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../Services/Data.dart';

final getIt = GetIt.instance;

class NamePicker extends StatefulWidget {
  const NamePicker({
    required
    this.isDay,
    Key? key,
  }) : super(key: key);

  final bool isDay;

  @override
  _NamePickerState createState() => _NamePickerState();
}

class _NamePickerState extends State<NamePicker> {

  final FocusNode _focusNode = FocusNode();
  Function? _button;

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
              child: Icon(Icons.sentiment_satisfied_rounded,color: neonAccent,size: 26.0,),
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
              child: Stack(
                alignment: Alignment.centerRight,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Name", style: widget.isDay
                            ? settingsTitle
                            : settingsTitle.copyWith(color: Colors.white)),
                        TextFormField(
                          style: settingsBody,
                          cursorColor: neon,
                          cursorRadius: const Radius.circular(20),
                          cursorWidth: 3,
                          enableSuggestions: false,
                          initialValue: getIt<Data>().username,
                          focusNode: _focusNode,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintStyle: Theme.of(context).textTheme.headline2!.copyWith(color: neon.withAlpha(250), fontSize: 24.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(1),borderSide: BorderSide(color: neon.withAlpha(50), width: 4)),
                            focusedBorder: const UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(2)),borderSide: BorderSide(color: neon, width: 5)),

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
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      disabledColor: neon.withAlpha(80),
                      onPressed: _button as void Function()?,
                      color: neon,
                      splashRadius: 30,
                      highlightColor: neon.withAlpha(80),
                      splashColor: neon.withAlpha(150),

                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}