import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String hintText;
  final String titleText;
  final int titleColor;
  final double fontSize;
  final TextInputType?
      inputType; //variable para capturar el tipo de dato a introducir
  final TextEditingController controller;
  final int maxLines;
  final int textColor;
  final int hintColor;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final int prefixIconColor;
  final int suffixIconColor;
  final bool isPasswordObscure;

  const TextInput(
      {Key? key,
      this.fontSize = 12.0,
      required this.hintText,
      required this.titleText,
      this.titleColor = 0xFF959360,
      required this.inputType,
      required this.controller,
      this.isPasswordObscure = false,
      this.prefixIconData,
      this.prefixIconColor = 0xFF000000,
      this.suffixIconData,
      this.suffixIconColor = 0xFF000000,
      this.maxLines = 1,
      this.textColor = 0xFF000000,
      this.hintColor = 0xFFBBBCC2})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextInput();
  }
}

class _TextInput extends State<TextInput> {
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 5.0),
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            widget.titleText,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(widget.titleColor), fontSize: widget.fontSize - 2),
          )),
      Container(
          //alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          decoration: BoxDecoration(
              color: const Color(0xFFE7E7EB),
              borderRadius: BorderRadius.circular(30.0)),
          child: TextField(
            obscureText: _isObscure,
            controller: widget.controller,
            keyboardType: widget.inputType,
            maxLines: widget.maxLines,
            style: TextStyle(
                fontSize: widget.fontSize,
                color: Color(widget.textColor),
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                //labelText: "Example",
                prefixIcon: Icon(
                  widget.prefixIconData,
                  color: Color(widget.prefixIconColor),
                ),
                suffixIcon: widget.isPasswordObscure
                    ? IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off_outlined),
                        color: Color(widget.suffixIconColor),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )
                    : Icon(widget.suffixIconData,
                        color: Color(widget.suffixIconColor)),
                filled: true,
                fillColor: const Color(0xFFE7E7EB),
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: Color(widget.hintColor), fontSize: widget.fontSize),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                    borderRadius: BorderRadius.all(Radius.circular(9.0))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                    borderRadius: BorderRadius.all(Radius.circular(9.0)))),
          ))
    ]);
  }
}
