import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class MoreItemBuilder extends StatelessWidget {
  const MoreItemBuilder({
    Key? key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final void Function()? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppPadding.p12,
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: greyColor,
          ),
        ),
        subtitle: subtitle != null ?Text(
          subtitle!,
        ) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        tileColor: pinkColor.withAlpha(10),
        leading: Icon(icon),
      ),
    );
  }
}
