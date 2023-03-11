
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/helpers/router_helper.dart';
import 'package:ramadan_kareem/utils/constants.dart';
import 'package:ramadan_kareem/utils/resources/assets_manger.dart';
import 'package:ramadan_kareem/utils/routes.dart';
import 'package:ramadan_kareem/view/screens/splash/splash_screen.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(ImageRes.logoReversed), context);
    precacheImage(const AssetImage(ImageRes.splashBG), context);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            fontFamily: 'Almarai',
          ),
          initialRoute: Routes.splashScreen,
          onGenerateRoute: RouterHelper.router.generator,
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: SplashScreen(),
          ),
        );
      },
    );
  }
}