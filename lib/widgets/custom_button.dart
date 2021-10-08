import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final double? width;
  final double height;
  final VoidCallback onPressed;
  final int backgroudColor;
  final double fontSize;
  final int fontColor;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.height,
      this.width,
      this.fontSize = 28.0,
      this.fontColor = 0xFFE7E7EB,
      this.backgroudColor = 0xFFFE7813})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    double _width;

    if (widget.width == null) {
      _width = screenWidht;
    } else {
      _width = widget.width!;
    }
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        alignment: Alignment.center,
        //margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        width: _width,
        height: widget.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            color: Color(widget.backgroudColor)
            /*gradient: const LinearGradient(
              colors: [Color(0xFFA7FF84), Color(0xFF1CBB78)],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)*/
            ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: widget.fontSize,
              //fontWeight: FontWeight.normal,
              color: Color(widget.fontColor)),
        ),
      ),
    );
  }
}
