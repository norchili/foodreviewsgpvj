import 'package:flutter/material.dart';

class LoginGradientBack extends StatelessWidget {
  final String? title;
  //final double? height;

  const LoginGradientBack({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //variable para obtener la altura de cualquier pantalla de un celular
    double screenHeight = MediaQuery.of(context).size.height - 136.0;
    double screenWidht = MediaQuery.of(context).size.width;

    return Stack(children: <Widget>[
      Container(
          width: screenWidht, height: 200.0, color: const Color(0xFF3C5D09)),
      Container(
          margin: const EdgeInsets.only(top: 136.0),
          width: screenWidht,
          height: screenHeight,
          decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0))))
    ]);
  }
}
