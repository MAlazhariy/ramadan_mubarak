import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/logging_interceptor.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:ramadan_kareem/utils/app_uri.dart';
import 'package:ramadan_kareem/utils/secret_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  late final SharedPreferences sharedPreferences;
  late final String baseUrl;
  late final LoggingInterceptor loggingInterceptor;

  late Dio dio;
  late String token;

  DioClient(
    this.baseUrl,
    Dio dioC, {
    required this.sharedPreferences,
    required this.loggingInterceptor,
  }) {
    token = sharedPreferences.getString(AppLocalKeys.TOKEN) ?? '';

    dio = dioC;
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        // 'Content-Type': 'application/json; charset=UTF-8',
        'X-localization': 'locale',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postFCM({
    String to = "/topics/${AppUri.ADMIN_FCM_TOPIC}",
    required String title,
    String body = '',
    Map<String, dynamic>? data,
  }) async {
    try {
      final dio = Dio();
      dio
        ..options.baseUrl = AppUri.FCM_BASE_URL
        ..options.connectTimeout = 30000
        ..options.receiveTimeout = 30000
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type': 'application/json',
          'Authorization': 'key=${AppSecretKeys.fcmServerKey}',
        };

      return await dio.post(
        AppUri.SEND_FCM,
        data:
          {
            "to": to,
            "notification": {
              "title": title,
              "body": body,
            },
            "android": {
              "priority": "HIGH",
              "notification": {
                "notification_priority": "PRIORITY_MAX",
                "sound": "Tri-tone",
                "default_sound": true
              }
            },
            "data": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              ...?data,
            }
          },
      );
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
