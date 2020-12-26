import 'package:Timo/Services/HiveDB.dart';
import 'package:Timo/hiveClasses/Zeitnahme.dart';
import 'package:fitted_text_field_container/fitted_text_field_container.dart';
import 'package:flutter/material.dart';

class TagEditWidget extends StatefulWidget {

  const TagEditWidget({
    this.i,
    this.color,
    this.colorAccent,
    this.zeitnahme
  });

  final Color colorAccent;
  final Color color;
  final int i;
  final Zeitnahme zeitnahme;

  @override
  _TagEditWidgetState createState() => _TagEditWidgetState();
}

class _TagEditWidgetState extends State<TagEditWidget> {

  TextEditingController _textEditingController;
  FocusNode _textFocus;

  @override
  void initState() {
    _textFocus = FocusNode();
    _textEditingController = TextEditingController(text: widget.zeitnahme.tag);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedFittedTextFieldContainer(
            growDuration: Duration(milliseconds: 200),
            growCurve: Curves.easeOutQuart,
            shrinkCurve: Curves.ease,
            child: TextField(
              maxLength: 50,
              cursorColor: widget.colorAccent,
              focusNode: _textFocus,
              controller: _textEditingController,
              style: TextStyle(
                color: widget.color,
                fontSize: 18,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),

                prefixText: "    ",
                counterText: "",
                disabledBorder: InputBorder.none,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
              onChanged: (value){
                setState(() {
                  getIt<HiveDB>().updateTag(value, widget.i);
                });
              },
              textCapitalization: TextCapitalization.words,
            ),
          ),
          IconButton(icon: Icon(Icons.edit, color: widget.color), onPressed: (){
            _textFocus.requestFocus();
          })
        ],
      ),
    );
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    _textFocus.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
