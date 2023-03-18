import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/base/error_response_model.dart';
import 'package:ramadan_kareem/helpers/notification_api.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:ramadan_kareem/ztrash/shared/components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

class SplashRepo {
  SplashRepo({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  bool isFirstOpen() {
    return sharedPreferences.getBool(AppLocalKeys.FIRST_OPEN) ?? true;
  }

  Future<ApiResponse> initAppData() async {
    try {
      // init Hive & open box
      await Hive.initFlutter();
      await Hive.openBox('box');

      // init local Notifications
      await NotificationApi.init(true);
      // init TimeZone
      tz.initializeTimeZones();

      // get init data
      await initGetAndSaveData();

      HijriCalendar.setLocal('ar');

      return ApiResponse.withSuccess();
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<bool> setIsAppFirstOpen([bool value = false]) async {
    return await sharedPreferences.setBool(AppLocalKeys.FIRST_OPEN, value);
  }

  Future<Map<String, dynamic>> getSplashAhadeeth() async {
    String jsonString = await rootBundle.loadString('assets/data/splash_ahadeeth.json');
    return json.decode(jsonString);
  }
}
