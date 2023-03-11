import 'package:flutter/material.dart';

Future pushAndFinish(
  BuildContext context,
  Widget screen,
) async {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: screen,
      ),
    ),
    (route) => false,
  );
}
