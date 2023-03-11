import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/providers/splash_provider.dart';
import 'package:ramadan_kareem/utils/resources/dimensions_manager.dart';
import 'package:ramadan_kareem/view/widgets/alert_dialog/alert_dialog.dart';

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
    final responseModel = await Provider.of<SplashProvider>(context, listen: false).getConfig();

    if (responseModel.isSuccess) {
      _onSuccessConfig();
    } else {
      if (!mounted) return;
      _onFailedConfig(context, responseModel.message!);
    }
  }

  Future<void> _onSuccessConfig() async {
    late final String screenRoute;
    final config = Provider.of<SplashProvider>(context, listen: false).configModel!;

    // set navigation route name
    if (!config.isSchoolActive) {
      screenRoute = Routes.getUpdateAppScreen(isUpdate: false);
    } else if (config.appConfig.status && config.appConfig.minVersion > AppConstants.appVersion) {
      screenRoute = Routes.getUpdateAppScreen(isUpdate: true);
    } else if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn) {
      screenRoute = Routes.getDashboardScreen();
    } else if (Provider.of<SplashProvider>(context, listen: false).isFirstOpen) {
      screenRoute = Routes.getOnBoardScreen();
    } else {
      screenRoute = Routes.getLoginScreen();
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, screenRoute, (route) => false);
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
            child: Text(
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
            backgroundColor: const Color(0xFF1B1B85),
            body: Stack(
              children: [
                // background
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        ImageRes.splashBG,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // center title & logo
                Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // logo
                      Container(
                        alignment: Alignment.center,
                        // height: AppSize.s40,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p16,
                          vertical: AppPadding.p20,
                        ),
                        child: const Image(
                          image: AssetImage(
                            ImageRes.logoReversed,
                          ),
                          color: Colors.white,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        'مركز د/ أحمد الجرايحي',
                        style: kExtraBoldFontStyle.copyWith(
                          fontSize: FontSize.s23,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSize.s20),
                    ],
                  ),
                ),
                // logo with description
                Center(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'لتعليم مادة الكيمياء',
                          style: kMediumFontStyle.copyWith(
                            color: Colors.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: AppSize.s5),
                        Text(
                          'لجميع المراحل التعليمية',
                          style: kMediumFontStyle.copyWith(
                            color: Colors.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: AppSize.s25),

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
