import 'package:ams_garaihy/utils/resources/color_manger.dart';
import 'package:flutter/material.dart';

class PageTitleWidget extends StatelessWidget {
  const PageTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: kGreyTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }
}
