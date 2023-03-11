import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/logging_interceptor.dart';
import 'package:ramadan_kareem/utils/app_uri.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class is a simple of Singleton Design Pattern concept.
class Di {
  static final sl = GetIt.instance;

  static Future<void> init() async {
    // Core
    sl.registerLazySingleton(() => DioClient(AppUri.FCM_URL, sl(), sharedPreferences: sl(), loggingInterceptor: sl()));

    // Repositories
    // sl.registerLazySingleton(() => AuthRepo(sharedPreferences: sl(), dioClient: sl()));

    // Providers
    // sl.registerFactoryParam<AuthProvider, ProfileProvider, void>((ProfileProvider profileProvider, _) => AuthProvider(authRepo: sl(), profileProvider: profileProvider));
    // sl.registerFactory(() => SplashProvider(sl()));

    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => LoggingInterceptor());
  }
}
