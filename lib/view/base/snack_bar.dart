import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';

class SnkBar {
  static void showSuccess(
      BuildContext context,
      String msg, {
        int milliseconds = 1500,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
        ),
        backgroundColor: kSuccessColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p12,
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

  static void showError(
      BuildContext context,
      String msg, {
        int milliseconds = 2500,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontSize: FontSize.s16,
            color: Colors.white,
          ),
        ),
        backgroundColor: kErrorColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p18,
          vertical: AppPadding.p12,
        ),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }

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
