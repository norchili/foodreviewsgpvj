import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String title;
  final String contentText;
  const ErrorAlertDialog(
      {Key? key, required this.title, required this.contentText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
            child: const Text(
              "Aceptar",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        TextButton(
            child: const Text(
              "Cancelar",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
