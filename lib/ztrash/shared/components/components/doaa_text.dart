import 'package:flutter/material.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class DoaaText extends StatelessWidget {
  const DoaaText({
    Key? key,
    required this.doaa,
  }) : super(key: key);

  final String doaa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          doaa,
          style: TextStyle(
            fontSize: 14.sp,
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
