
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/helpers/fcm_helper.dart';
import 'package:ramadan_kareem/helpers/notification_api.dart';
import 'package:ramadan_kareem/helpers/router_helper.dart';
import 'package:ramadan_kareem/my_app.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/doaa_provider.dart';
import 'package:ramadan_kareem/providers/field_doaa_provider.dart';
import 'package:ramadan_kareem/providers/internet_provider.dart';
import 'package:ramadan_kareem/providers/profile_provider.dart';
import 'package:ramadan_kareem/providers/splash_provider.dart';
import 'package:ramadan_kareem/utils/di_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set device orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // init routes
  RouterHelper.init();

  // init singleton
  await Di.init();

  // init Firebase
  await Firebase.initializeApp();

  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('fcm token: $token');

  // init local Notifications
  await NotificationApi.init(true);

  // init fcm listeners
  FCMHelper.listener();

  // Setting SystemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      // statusBarIconBrightness: Brightness.dark,
    ),
  );
  //Setting SystemUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Di.sl<SplashProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<InternetProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<FieldDoaaProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<DoaaProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<ProfileProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

