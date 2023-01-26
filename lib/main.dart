import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/modules/settings/admin/admin_screen.dart';
import 'package:ramadan_kareem/layout/home_screen.dart';
import 'package:ramadan_kareem/modules/notification_api.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:sizer/sizer.dart';
import 'layout/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // prevent device orientation changes & force portrait
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // init FireBase
  await Firebase.initializeApp();

  // init Hive & open box
  await Hive.initFlutter();
  await Hive.openLazyBox('box');

  // init Notification
  await NotificationApi.init(true);

  // init TimeZone
  tz.initializeTimeZones();

  // set device id
  deviceId = await PlatformDeviceId.getDeviceId;

  // get init data
  await initGetAndSaveData();

  HijriCalendar.setLocal('ar');

  runApp(const MyApp());
}

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

