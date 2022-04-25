import 'package:flutter/material.dart';

void snkbar(
  BuildContext context,
  String msg, {
  int seconds = 3,
  Color backgroundColor,
  TextStyle textStyle,
  void Function() action,
  String actionLabel = '',
  Color labelColor = Colors.white,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: textStyle,
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: backgroundColor,
    action: SnackBarAction(
      onPressed: action??(){},
      label: actionLabel,
      textColor: labelColor,
    ),
  ));
}
