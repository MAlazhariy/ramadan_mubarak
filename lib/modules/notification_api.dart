import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();


  static Future notificationDetails() async {

    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        channelDescription: 'CHANNEL_DESCRIPTION',
        importance: Importance.max,
        icon: 'ic_stat_name',
      ),
    );

  }

  static Future init([bool initScheduled = false]) async {
    const _android = AndroidInitializationSettings('ic_stat_name');
    const ios = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    );

    // tz.initializeTimeZones();

    await _notifications.initialize(
      const InitializationSettings(
        android: _android,
        iOS: ios,
      ),
    );
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
      await notificationDetails(),
      payload: payload,
    );
  }

  static void showScheduledNotification({
    int id = 1,
    @required String title,
    @required String body,
    String payload = '',
    @required DateTime date,
  }) async {
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      await notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


}
