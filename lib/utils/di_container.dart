import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/logging_interceptor.dart';
import 'package:ramadan_kareem/data/repository/auth_repo.dart';
import 'package:ramadan_kareem/data/repository/doaa_repo.dart';
import 'package:ramadan_kareem/data/repository/splash_repo.dart';
import 'package:ramadan_kareem/providers/auth_provider.dart';
import 'package:ramadan_kareem/providers/doaa_provider.dart';
import 'package:ramadan_kareem/providers/field_doaa_provider.dart';
import 'package:ramadan_kareem/providers/internet_provider.dart';
import 'package:ramadan_kareem/providers/splash_provider.dart';
import 'package:ramadan_kareem/utils/app_uri.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class is a simple of Singleton Design Pattern concept.
class Di {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    // Core
    sl.registerLazySingleton(() => DioClient(AppUri.BASE_URL, sl(), sharedPreferences: sl(), loggingInterceptor: sl()));

    // Repositories
    sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl()));
    sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl(), dioClient: sl()));
    sl.registerLazySingleton(() => DoaaRepo(sharedPreferences: sl(), dioClient: sl()));

    // Providers
    sl.registerFactory(() => SplashProvider(sl()));
    sl.registerFactory(() => InternetProvider());
    sl.registerFactory(() => AuthProvider(authRepo: sl()));
    sl.registerFactory(() => FieldDoaaProvider());
    sl.registerFactory(() => DoaaProvider(sl()));

    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => LoggingInterceptor());
  }
}
