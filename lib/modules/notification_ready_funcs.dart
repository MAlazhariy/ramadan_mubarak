import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ramadan_kareem/modules/notification_api.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/custom_dialog.dart';
import 'package:ramadan_kareem/shared/components/components/custom_dialog/dialog_buttons.dart';
import 'package:ramadan_kareem/shared/components/components/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';

void readyShowScheduledNotification(BuildContext context) async {
  Position position = await _determinePosition(context);
  final coordinates = Coordinates(position.latitude, position.longitude);
  // final date = DateComponents(2022, 04, 03);
  final calculationParameters =
      CalculationMethod.muslim_world_league.getParameters();
  calculationParameters.madhab = Madhab.shafi;

  for (int i = 0; i < 30; i++) {
    DateTime date = DateTime.now().add(Duration(days: i));
    int hijriDayInt = HijriCalendar.fromDate(date).hDay;
    int hijriMonthInt = HijriCalendar.fromDate(date).hMonth;

    if (hijriMonthInt != 9) {
      // todo: remove this line
      snkbar(context, 'تم ضبط الإشعارات بنجاح 💙');
      Cache.notificationsDone();
      break;
    }

    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents(date.year, date.month, date.day),
      calculationParameters,
    );

    int _random = getRandomIndex();
    String notifiName = Cache.getName(_random);
    String notifiDoaa = Cache.getDoaa(_random);

    var scheduledDate = DateTime(
      date.year,
      date.month,
      date.day,
      prayerTimes.maghrib.hour,
      prayerTimes.maghrib.minute - 10,
      prayerTimes.maghrib.second,
    ).toLocal();

    log('--------');
    log('scheduledDate = $scheduledDate');
    // log('--------');

    NotificationApi.showScheduledNotification(
      title: '$hijriDayInt اقترب موعد استجابة الدعاء',
      body: 'هيا ندعي لـ $notifiName\n$notifiDoaa',
      date: scheduledDate,
      // todo: edit to time of maghreb pray time
      repeatDuration: Duration(seconds: 5 * (i + 1)),
      id: hijriDayInt,
    );
  }
}


Future<Position> _determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    snkbar(context, 'يرجى فتح الموقع الجغرافي GPS للسماح للتطبيق بتحديد مواعيد الصلاة الصحيحة بناءاً على منطقتك الجغرافية');

    // await Geolocator.openLocationSettings();
    // showCustomDialog(
    //   context: context,
    //   title: 'يرجى فتح الموقع الجغرافي',
    //   content: const Text(
    //     'يرجي فتح الموقع الجغرافي GPS للسماح للتطبيق بمعرفة مواعيد صلاة المغرب',
    //     style: TextStyle(
    //       height: 1.8
    //     ),
    //   ),
    //   buttons: [
    //     DialogButton(
    //       title: 'سماح',
    //       onPressed: () async {
    //         await Geolocator.openLocationSettings();
    //         Navigator.pop(context);
    //       },
    //     ),
    //   ],
    // );

    // return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      snkbar(context, 'السماح بالوصول للموقع يساعد في ظهور الإشعارات في الوقت الصحيح قبل مواعيد صلاة المغرب');
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are denied forever!, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
