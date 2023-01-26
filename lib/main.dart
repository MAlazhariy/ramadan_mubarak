
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/modules/notification_api.dart';
import 'package:ramadan_kareem/my_app.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set device orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

