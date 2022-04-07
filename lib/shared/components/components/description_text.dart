import 'package:flutter/material.dart';
import 'package:ramadan_kareem/shared/styles.dart';
import 'package:sizer/sizer.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: greyColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
