import 'package:ams_garaihy/utils/resources/assets_manger.dart';
import 'package:ams_garaihy/view/screens/on_boarding/widgets/page_image_widget.dart';
import 'package:ams_garaihy/view/screens/on_boarding/widgets/page_title_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BoardPage1 extends StatelessWidget {
  const BoardPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PageImageWidget(image: ImageRes.onBoard1),
            PageTitleWidget(
              title: 'on_board_title_1'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
