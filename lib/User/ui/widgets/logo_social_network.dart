import 'package:flutter/material.dart';

class SocialNetworkLogo extends StatefulWidget {
  final VoidCallback onPresed;
  final String pathLogo;
  final double widht;
  const SocialNetworkLogo(
      {Key? key,
      required this.onPresed,
      required this.pathLogo,
      required this.widht})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SocialNetworkLogo();
  }
}

class _SocialNetworkLogo extends State<SocialNetworkLogo> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPresed,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            width: widget.widht,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE7E7EB), width: 1),
                borderRadius: BorderRadius.circular(24.0)),
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(widget.pathLogo), fit: BoxFit.cover)),
            )));
  }
}
