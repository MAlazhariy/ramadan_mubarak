import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        // todo: handle notification screen showTime
        'CHANNEL_ID 2',
        'doaa reminder 2', // channel name
        channelDescription: 'CHANNEL_DESCRIPTION 1',
        importance: Importance.max,
        styleInformation: BigTextStyleInformation(''),
        visibility: NotificationVisibility.public,
        enableVibration: true,
        fullScreenIntent: true,
        icon: 'ic_stat_name',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_audio'),
      ),
    );
  }

  static Future init([bool initScheduled = false]) async {
    const _android = AndroidInitializationSettings('ic_stat_name');
    // const ios = IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );

    // /// when app is closed
    // final details = await _notifications.getNotificationAppLaunchDetails();
    // if(details != null && details.didNotificationLaunchApp){
    //
    // }

    await _notifications.initialize(
      const InitializationSettings(
        android: _android,
        // iOS: ios,
      ),
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    @required String title,
    @required String body,
    String payload = '',
  }) async {
    return _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  static void showScheduledNotification({
    int id = 1,
    @required String title,
    @required String body,
    String payload = '',
    @required DateTime date,
    // @required Time time,
    Duration repeatDuration = const Duration(days: 1),
  }) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      // _scheduleDaily(date , repeatDuration),
      tz.TZDateTime.from(date, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      /// method if you want to daily schedule notifications
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleDaily(
      DateTime date,
      // Time time,
      Duration repeatDuration,
  ) {
    final now = tz.TZDateTime.now(tz.local).toUtc();
    final scheduledDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
    );

    // todo: remove print mehods
    if (scheduledDate.isBefore(now)) {
      // log('will show after $repeatDuration');
      log('date is before now .. will show at ${now.add(repeatDuration)}');
      return now.add(repeatDuration);
    }
    // log('time zone now = $now');
    log('will show at $scheduledDate');
    return scheduledDate;
  }
}
