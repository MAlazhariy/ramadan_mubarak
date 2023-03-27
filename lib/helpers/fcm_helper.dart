import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/helpers/notification_api.dart';

class FCMHelper {
  static listener({
    void Function(RemoteMessage event)? onMessage,
    void Function(RemoteMessage event)? onMessageOpenedApp,
  }) {
    debugPrint('- start my fcm listener ...');
    // App is opened
    FirebaseMessaging.onMessage.listen((event) => onMessage ?? _onMessageListener(event));

    // App is terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) => onMessageOpenedApp ?? _onMessageOpenedListener(message));

    // App is killed in background
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
  }

  static whenAppOpenedFromNotificationListener() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // todo: check if there's current call or no
    });
  }

  // when app is opened
  static void _onMessageListener(RemoteMessage event) {
    debugPrint('-- onMessage: ${event.data}');
    debugPrint('message title: ${event.notification?.title}');
    debugPrint('message type: ${event.data['type']}');
    debugPrint('message data: ${event.data}');
    log('-- onMessage: ${event.notification?.title}');

    NotificationApi.showNotification(
      title: event.notification!.title!,
      body: event.notification!.body!,
    );
  }

  // when app is terminated or killed and received fcm
  @pragma('vm:entry-point')
  static void _onMessageOpenedListener(RemoteMessage message) {
    debugPrint('-- onMessageOpenedApp: ${message.data}');
  }

  // when app is terminated or killed in background and received fcm
  @pragma('vm:entry-point')
  static Future<void> _onBackgroundHandler(RemoteMessage message) async {
    debugPrint('-- onBackgroundMessage: ${message.data}');

  }
}
