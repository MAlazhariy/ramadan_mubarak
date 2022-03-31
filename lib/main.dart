import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_kareem/shared/components/constants.dart';
import 'package:sizer/sizer.dart';
import 'modules/login_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // prevent device orientation changes & force portrait
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('box');

  tz.initializeTimeZones();

  await getInitData();
  // await AndroidAlarmManager.initialize();

  // await AndroidAlarmManager.oneShot(const Duration(seconds: 3), 15, (){
  //   log('hello in ${DateTime.now()}');
  // });

  HijriCalendar.setLocal('ar');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType){
        return MaterialApp(
          title: 'رمضان مبارك',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            fontFamily: 'Almarai',
          ),
          home: const Directionality(
            textDirection: TextDirection.rtl,
            child: LoginScreen(),
          ),
        );
      },
    );
  }
}