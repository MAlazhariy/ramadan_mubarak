import 'package:flutter/material.dart';

void snkbar(
  BuildContext context,
  String msg, {
  int seconds = 3,
  Color backgroundColor,
  TextStyle textStyle,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: textStyle,
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: backgroundColor,
  ));
}
