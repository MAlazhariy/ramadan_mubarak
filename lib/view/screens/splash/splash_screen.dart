import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/internet_provider.dart';
import 'package:ramadan_kareem/providers/splash_provider.dart';
import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/resources/color_manger.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/utils/resources/font_manager.dart';
import 'package:ramadan_kareem/utils/resources/text_styles_manager.dart';
import 'package:ramadan_kareem/utils/routes.dart';
import 'package:ramadan_kareem/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:ramadan_kareem/view/widgets/internet_consumer_builder.dart';
import 'package:ramadan_kareem/ztrash/shared/styles.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  Future<void> init() async {
    if (!mounted) return;
    final responseModel = await Provider.of<SplashProvider>(context, listen: false).initAppData();

    if (responseModel.isSuccess) {
      _onSuccessConfig();
    } else {
      if (!mounted) return;
      _onFailedConfig(context, responseModel.message!);
    }
  }

  Future<void> _onSuccessConfig() async {
    late final String screenRoute;

    // set navigation route name
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn) {
      screenRoute = Routes.getDashboardScreen();
    } else if (Provider.of<SplashProvider>(context, listen: false).isFirstOpen) {
      screenRoute = Routes.getOnBoardScreen();
    } else {
      screenRoute = Routes.getLoginScreen();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    // Navigator.pushNamedAndRemoveUntil(context, screenRoute, (route) => false);
  }

  void _onFailedConfig(BuildContext context, String errorMsg) {
    /// quit if not mounted or is there no internet connection
    if (!mounted || Provider.of<InternetProvider>(context, listen: false).noInternetConnection) return;
    showErrorDialog(
      context: context,
      description: errorMsg,
      buttons: [
        MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                init();
              });
            },
            child: const Text(
              "حاول مرة أخرى",
            )),
      ],
    );
    // SnkBar.showError(context, errorMsg);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return InternetConsumerBuilder(
      builder: (context, provider) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              alignment: Alignment.center,
              children: [
                // background
                SvgPicture.asset(
                  ImageRes.svg.splashBG,
                  fit: BoxFit.cover,
                ),
                // center title & logo
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Container(
                        // alignment: Alignment.center,
                        // height: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.w,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p30,
                          vertical : AppPadding.p20,
                        ),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: pinkColor,
                            strokeAlign: 0,
                            width: 1.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 4,
                              spreadRadius: 0,
                              offset: const Offset(1,3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // icon
                            // SvgPicture.asset(
                            //   ImageRes.svg.quoteIcon,
                            //   height: 38,
                            // ),
                            const SizedBox(height: AppSize.s20),
                            // quote
                            Text(
                              'قَالَ رَسُول اللَّه ﷺ: (دَعْوةُ المرءِ المُسْلِمِ لأَخيهِ بِظَهْرِ الغَيْبِ مُسْتَجَابةٌ، عِنْد رأْسِهِ ملَكٌ مُوكَّلٌ كلَّمَا دَعَا لأَخِيهِ بخيرٍ قَال المَلَكُ المُوكَّلُ بِهِ: آمِينَ، ولَكَ بمِثْلٍ).',
                              style: kBoldFontStyle.copyWith(
                                fontSize: 14.sp,
                                height: 1.65,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: AppSize.s20),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(AppPadding.p15),
                      child: SvgPicture.asset(
                        ImageRes.svg.quoteIcon,
                        height: 38,
                        color: pinkColor,
                      ),
                    ),
                  ],
                ),
                // logo
                Center(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          ImageRes.svg.bonyanLogo,
                          width: 24,
                        ),
                        const SizedBox(height: AppSize.s16),

                        // loading progress
                        Consumer<SplashProvider>(
                          builder: (context, splashProvider, _) {
                            if (splashProvider.isLoading) {
                              return SizedBox(
                                height: AppSize.s20,
                                width: AppSize.s20,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  backgroundColor: Platform.isIOS ? Colors.white : null,
                                  strokeWidth: 2.4,
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),

                        const SizedBox(
                          height: AppPadding.p25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      },
      onRestoreInternetConnection: () {
        init();
      },
    );
  }
}
