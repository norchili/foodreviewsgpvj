import 'package:flutter/material.dart';

class SocialNetworkLogo extends StatefulWidget {
  final VoidCallback onPresed;
  final String pathLogo;
  const SocialNetworkLogo(
      {Key? key, required this.onPresed, required this.pathLogo})
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
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(widget.pathLogo), fit: BoxFit.cover)),
        ));
  }
}
