import 'package:flutter/material.dart';

// const kMainColor = Color(0xFFEE3E3C);
const kMainColor = Color(0xFF0B0C91);
const kPrimarySemiLightColor = Color(0xFF6769B9);
const kPrimaryLightColor = Color(0xffb6b6de);
const kCorrectAnswerColor = Colors.green;
const kWrongAnswerColor = Colors.red;
const kTitleColor = Color(0xFF2E2E46);
const kSecondaryColor = Color(0xFFF90DCC);
const kGreyTextColor = Color(0xFF696973);
const kBorderColorTextField = Color(0xFFC2C2C2);
const kDarkWhite = Color(0xFFF1F7F7);
const kWhiteColor = Colors.white;
const kScaffoldBG = Color(0xFFF2F1F7);
const kErrorColor = Color(0xFF9B0C0C);
const kSuccessColor = Color(0xFF1A9B0C);

const _kListColors = <Color>[
  Color(0xFFFBECD9),
  Color(0xFFD2E4FF),
  Color(0xFFE1DDFF),
  Color(0xFFFBEAE2),
  Color(0xFFDEEDE8),
  Color(0xFFE5F2DC),
  Color(0xFFF8E2E2),
  Color(0xFFE1D5FC),
];

const MaterialColor kPrimarySwatch = MaterialColor(
  0xFF0B0C91,
  <int, Color>{
    50: Color(0xffe7e7f4), //10%
    100: Color(0xffb6b6de), //20%
    200: Color(0xff8586c8), //30%
    300: Color(0xff5455b2), //40%
    400: Color(0xFF0B0C91), //50% DEFAULT
    500: Color(0xff090a74), //60%
    600: Color(0xff080866), //70%
    700: Color(0xff070757), //80%
    800: Color(0xff060649), //90%
    900: Color(0xff04053a), //100%
  },
);

Color getListItemColor(int index){
  return _kListColors[index % _kListColors.length];
}