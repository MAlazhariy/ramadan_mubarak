import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required Widget content,
  List<Widget> buttons = const <Widget>[],
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
            ),
          ),
          content: SizedBox(
            width: 65.w,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  content,
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Center(
                child: Wrap(
                  spacing: 4.sp,
                  children: buttons,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.sp),
          ),
        ),
      );
    },
  );
}
