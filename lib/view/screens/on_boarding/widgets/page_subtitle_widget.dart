import 'package:flutter/material.dart';

class PageSubtitleWidget extends StatelessWidget {
  const PageSubtitleWidget({
    Key? key,
    required this.subTitle,
  }) : super(key: key);

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitle,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }
}
