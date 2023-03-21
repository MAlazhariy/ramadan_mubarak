import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.fontSize = FontSize.s17,
    this.horizontalContentPadding = 70,
    this.verticalContentPadding = 15,
    this.fit = true,
    this.outlined = false,
    this.strokeAlign = BorderSide.strokeAlignInside,
    this.flat = false,
  }) : super(key: key);

  final void Function()? onPressed;
  final String title;
  final double fontSize;
  final bool fit;
  final bool outlined;
  final double strokeAlign;
  final double horizontalContentPadding;
  final double verticalContentPadding;

  /// Flat color.
  /// If [true] gradient is disabled.
  final bool flat;

  bool get _activated => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        highlightColor: kPrimarySemiLightColor.withAlpha(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14),
        ),
        highlightElevation: 5,
        child: Ink(
          decoration: BoxDecoration(
            color: !_activated
                ? Colors.grey[400]
                : flat && !outlined
                    ? kMainColor
                    : null,
            gradient: flat
                ? null
                : const LinearGradient(
                    colors: [
                      Color(0XFFFF4AA3),
                      Color(0XFFF8B556),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
            borderRadius: BorderRadius.circular(AppSize.s14),
            border: outlined
                ? Border.all(
                    color: _activated ? kMainColor : Colors.grey.shade400,
                    width: 2,
                    strokeAlign: strokeAlign,
                  )
                : null,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalContentPadding,
              vertical: verticalContentPadding,
            ),
            width: fit ? double.maxFinite : null,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: kBoldFontStyle.copyWith(
                color: outlined ? kMainColor : kWhiteColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
