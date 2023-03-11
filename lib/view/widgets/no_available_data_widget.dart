import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:flutter/material.dart';

class NoAvailableDataWidget extends StatelessWidget {
  const NoAvailableDataWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.s50,
        vertical: AppSize.s40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageRes.emptyBoxIcon,
            width: 80,
            color: kGreyTextColor,
          ),
          const SizedBox(height: AppSize.s5),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: kSemiBoldFontStyle.copyWith(
              fontSize: FontSize.s16 - 1,
              color: kGreyTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
