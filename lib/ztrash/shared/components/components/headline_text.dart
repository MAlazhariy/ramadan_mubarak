import 'package:flutter/material.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class HeadlineText extends StatelessWidget {
  const HeadlineText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15.sp,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: pinkColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
