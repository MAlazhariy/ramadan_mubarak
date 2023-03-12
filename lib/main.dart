
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ramadan_kareem/helpers/router_helper.dart';
import 'package:ramadan_kareem/my_app.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/internet_provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Di.sl<SplashProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<InternetProvider>()),
        ChangeNotifierProvider(create: (context) => Di.sl<AuthProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

