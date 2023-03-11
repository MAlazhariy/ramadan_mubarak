import 'package:flutter/material.dart';

Future pushTo(
  BuildContext context,
  Widget screen,
) async {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: screen,
      );
    }),
  );
}
