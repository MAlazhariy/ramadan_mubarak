import 'package:flutter/material.dart';

class SnkBar {
  static void show(
    BuildContext context, {
    required String message,
    int seconds = 3,
    Color? backgroundColor,
    TextStyle? textStyle,
    SnackBarAction? snackBarAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle,
        ),
        duration: Duration(seconds: seconds),
        backgroundColor: backgroundColor,
        action: snackBarAction,
      ),
    );
  }
}
