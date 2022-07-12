import 'package:flutter/material.dart';

class DarkTheme {
  static const Color backColor = Color.fromRGBO(32, 33, 36, 1);
  static const Color borderColor = Color.fromRGBO(95, 99, 104, 1);
  static const Color fontColor = Colors.white;
}

showSnackbar(BuildContext context, String text) {
  final snackBar = SnackBar(
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: const TextStyle(color: DarkTheme.fontColor),
      ),
      backgroundColor: DarkTheme.borderColor);

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
