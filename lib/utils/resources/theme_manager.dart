import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';

class ThemeManager {
  static ThemeData light = ThemeData(
    /// main colors
    primaryColor: kMainColor,
    primarySwatch: kPrimarySwatch,
    scaffoldBackgroundColor: kScaffoldBG,
    // primaryColorLight: ColorManager.kLightPrimary,
    // primaryColorDark: ColorManager.kDarkPrimary,
    // disabledColor: ColorManager.kGray1,
    // splashColor: ColorManager.kLightPrimary,

    /// font family
    fontFamily: FontFamily.almarai,

    // Add the line below to get horizontal sliding transitions for routes.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      },
    ),

    /// appBar theme
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: kPrimaryLightColor,
      elevation: 0,
    ),

    /// button theme
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s5),
      ),
      buttonColor: kMainColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p16,
        horizontal: AppPadding.p18,
      ),
      minWidth: double.infinity,
    ),

    /// elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: kMediumFontStyle.copyWith(
          fontSize: FontSize.s14,
          color: Colors.white,
        ),
        backgroundColor: kMainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s5),
        ),

        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p16,
          horizontal: AppPadding.p18,
        ),
      ),
    ),

    /// text theme
    // textTheme: TextTheme(
    //   displayLarge: kBoldFontStyle.copyWith(
    //     color: ColorManager.kWhite,
    //     fontSize: FontSize.kLarge,
    //   ),
    //   headlineMedium: kBoldFontStyle.copyWith(
    //     color: ColorManager.kDarkGray,
    //     fontSize: FontSize.kDefault,
    //   ),
    //   labelMedium: kBoldFontStyle.copyWith(
    //     color: ColorManager.kLightGray,
    //     fontSize: FontSize.kDefault,
    //   ),
    //   titleMedium: kBoldFontStyle.copyWith(
    //     color: ColorManager.kGray1,
    //   ),
    //   bodyMedium: kBoldFontStyle.copyWith(
    //     color: ColorManager.kGray,
    //   ),
    // ),

    /// input decoration theme
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: kPrimaryLightColor,
          width: 1.5,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: kMainColor,
          width: 2,
        ),
      ),

      border: OutlineInputBorder(
        borderSide: BorderSide(color: kMainColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: kErrorColor,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: kErrorColor,
          width: 1.5,
        ),
      ),
      filled: false,
      hintStyle: TextStyle(
        color: kPrimaryLightColor,
      ),
      labelStyle: TextStyle(
        color: kMainColor,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: AppPadding.p15,
        horizontal: AppPadding.p15,
      ),
      suffixIconColor: kPrimaryLightColor,
    ),
  );


  // static ThemeData dark = ThemeData();
}








