import 'package:flutter/material.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/view/widgets/main_button.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.s20,
            horizontal: AppSize.s50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: AppSize.s80 + 10,
                // color: Colors.red,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: AppSize.s20),
              Text(
                'لقد تم حظر حسابك',
                style: kBoldFontStyle.copyWith(
                  fontSize: FontSize.s25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSize.s8),
              const Text(
                'لا يمكنك اتخاذ هذا الإجراء حالياً لأنه قد تم حظر هذا الحساب.',
                style: kRegularFontStyle,
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: AppSize.s50),
              // MainButton(
              //   title: 'تسجيل خروج',
              //   outlined: true,
              //   // fit: false,
              //   onPressed: () {
              //     Provider.of<AuthProvider>(context, listen: false).logoutAndClearData();
              //     Navigator.pushNamedAndRemoveUntil(context, Routes.getLoginScreen(), (route) => false);
              //   },
              // ),
              const SizedBox(height: AppSize.s12),
              if (Navigator.canPop(context))
                MainButton(
                  title: 'رجوع',
                  outlined: true,
                  // fit: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
