
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/helpers/notification_api.dart';
import 'package:ramadan_kareem/my_app.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set device orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // init FireBase
  await Firebase.initializeApp();

  // init TimeZone
  tz.initializeTimeZones();

  // get init data
  await initGetAndSaveData();

  HijriCalendar.setLocal('ar');

  runApp(const MyApp());
}

