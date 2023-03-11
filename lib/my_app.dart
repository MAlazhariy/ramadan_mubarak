
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/view/screens/home/home_screen.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:sizer/sizer.dart';
import 'view/screens/login/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'رمضان مبارك',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            fontFamily: 'Almarai',
          ),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: StartScreen(),
            // child: HomeScreen(),
          ),
        );
      },
    );
  }
}


class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // if(deviceId == '3a9a32a9d64d9dcf' || deviceId == 'd592267254ebbd0e'){
    //   return const AdminScreen();
    // }

    if(Cache.isLogin()) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }

  }
}