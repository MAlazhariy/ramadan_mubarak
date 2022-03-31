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
        'CHANNEL_ID',
        'CHANNEL_NAME',
        channelDescription: 'CHANNEL_DESCRIPTION',
        importance: Importance.max,
        fullScreenIntent: true,
        icon: 'ic_stat_name',
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

    /// when app is closed
    final details = await _notifications.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){

    }

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
    // DateTime date,
    @required Time time,
    Duration repeatDuration = const Duration(days: 1),
  }) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(time , repeatDuration),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleDaily(
    Time time,
    Duration repeatDuration,
  ) {
    final now = tz.TZDateTime.now(tz.local).toUtc();
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );

    if (scheduledDate.isBefore(now)) {
      print('will show after $repeatDuration');
      print('will show at ${now.add(repeatDuration)}');
      return now.add(repeatDuration);
    }
    print(scheduledDate.isBefore(now));
    print('time zone now = $now');
    print('scheduledDate = $scheduledDate');
    print('will show at $scheduledDate');
    return scheduledDate;
  }
}
