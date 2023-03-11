
import 'dart:async';
import 'dart:developer';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:ramadan_kareem/helpers/notification_api.dart';
import 'package:ramadan_kareem/shared/cache_helper/cache_helper.dart';
import 'package:ramadan_kareem/view/widgets/snack_bar.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';

void readyShowScheduledNotification(BuildContext context) async {

  Coordinates coordinates;

  if(Cache.isCoordinatesSaved()){
    coordinates = Coordinates(Cache.getLatitude(), Cache.getLongitude());
  } else {
    Position position = await _determinePosition(context);
    coordinates = Coordinates(position.latitude, position.longitude);
    Cache.setCoordinates(coordinates.latitude, coordinates.longitude);
  }

  final calculationParameters =
      CalculationMethod.muslim_world_league.getParameters();
  calculationParameters.madhab = Madhab.shafi;
  final DateTime now = DateTime.now();

  for (int i = 0; i < 30; i++) {
    DateTime date = DateTime.now().add(Duration(days: i));
    int hijriDayInt = HijriCalendar.fromDate(date).hDay;
    int hijriMonthInt = HijriCalendar.fromDate(date).hMonth;

    if (hijriMonthInt != 9) {
      var users = userModel?.data.where((element) => element.deviceId == deviceId);
      String callUser = '';
      if(users?.isNotEmpty??false){
        callUser = ' يا ${users!.first.name}';
      }

      SnkBar(context, 'تم ضبط الإشعارات بنجاح ✅');

      NotificationApi.showScheduledNotification(
        title: 'عيد سعيد 🎉🎈',
        body: 'كل عام وأنت بخير$callUser 💙',
        date: DateTime(
          date.year,
          date.month,
          date.day,
          6,
        ).toLocal(),
        id: 32,
      );

      Cache.notificationsDone();
      break;
    }

    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents(date.year, date.month, date.day),
      calculationParameters,
    );

    int _random = getRandomIndex();
    String notifiName = userModel?.data[_random].name ??'';
    String notifiDoaa = userModel?.data[_random].doaa ??'';

    var scheduledDate = DateTime(
      date.year,
      date.month,
      date.day,
      prayerTimes.maghrib.hour,
      prayerTimes.maghrib.minute - 17,
      prayerTimes.maghrib.second,
    ).toLocal();

    log('--------');
    log('scheduledDate = $scheduledDate');
    // log('--------');

    if (scheduledDate.isBefore(now)) {
      log('scheduledDate is before now');
      continue;
    }

    NotificationApi.showScheduledNotification(
      title: 'اقترب موعد استجابة الدعاء',
      body: 'هيا ندعي لـ $notifiName\n$notifiDoaa',
      date: scheduledDate,
      repeatDuration: Duration(seconds: 5 * (i + 1)),
      id: hijriDayInt,
    );

    log('done $hijriDayInt');
  }
}

Future<Position> _determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    print('location service is not Enabled');
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    // snkbar(context,
    //     'يرجى فتح الموقع الجغرافي GPS للسماح للتطبيق بتحديد مواعيد الصلاة الصحيحة بناءاً على منطقتك الجغرافية');

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
  print('check Permission..');
  if (permission == LocationPermission.denied) {
    print('permission denied 😢');
    permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    //   // Permissions are denied, next time you could try
    //   // requesting permissions again (this is also where
    //   // Android's shouldShowRequestPermissionRationale
    //   // returned true. According to Android guidelines
    //   // your App should show an explanatory UI now.
    //   snkbar(context,
    //       'السماح بالوصول للموقع يساعد في ظهور الإشعارات في الوقت الصحيح قبل مواعيد صلاة المغرب');
    //   return Future.error('Location permissions are denied');
    // }
    // return Future.error('Location permissions are denied');
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
