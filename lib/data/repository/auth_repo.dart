import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/data/repository/profile_repo.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:ramadan_kareem/utils/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo({
    required this.sharedPreferences,
    required this.dioClient,
  });

  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  // is logged in
  bool get isLoggedIn => sharedPreferences.containsKey(AppLocalKeys.USER_ID);

  // login
  Future<ApiResponse> login({
    required String name,
    required String doaa,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      // TODO: HANDLE DEVICE_ID
      final deviceId = await PlatformDeviceId.getDeviceId;
      final docId = deviceId ?? '${now.millisecondsSinceEpoch}-$name';
      final token = await FirebaseMessaging.instance.getToken();
      final user = UserDetails(id: docId, name: name, doaa: doaa, time: now, deviceId: deviceId);

      debugPrint('user details: ${user.toJson()}');

      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(docId).set({
        ...user.toJson(),
        'name_update': '',
        'doaa_update': '',
        'token': token ?? '',
      });

      await _saveUserId(docId);
      await Di.sl<ProfileRepo>().updateUserData(user);
      await _sendNotification(user);

      return ApiResponse.withSuccess();
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  /// check is user exists in Database or not.
  /// you should check at the first open.
  Future<bool> checkIsUserExists() async {
    try {
      final deviceId = await PlatformDeviceId.getDeviceId;
      if(deviceId == null){
        return false;
      }

      final data = await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(deviceId).get();

      if(!data.exists){
        return false;
      }

      final user = UserDetails.fromJson(
        data.data()!,
        id: data.id,
      );

      await _saveUserId(deviceId);
      await Di.sl<ProfileRepo>().updateUserData(user);
      await _updateToken(deviceId);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ApiResponse> _updateToken(String id) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(id).update({
        'token': token ?? '',
      });

      return ApiResponse.withSuccess();
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> _sendNotification(UserDetails user) async {
    try {
      final response = await dioClient.postFCM(user: user);
      debugPrint('fcm response: [${response.statusCode}] ${response.data}');
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<void> _saveUserId(String id) async {
    // save token in shared-pref
    try {
      await sharedPreferences.setString(AppLocalKeys.USER_ID, id);
    } catch (e) {
      rethrow;
    }
  }

// Future<bool> logout() async {
//   if (!kIsWeb) {
//     // await FirebaseMessaging.instance.unsubscribeFromTopic(AppStrings.TOPIC);
//   }
//   await sharedPreferences.remove(AppStrings.TOKEN);
//   // await sharedPreferences.remove(AppStrings.SEARCH_ADDRESS);
//
//   dioClient
//     ..token = ''
//     ..firebase.options.headers.update('Authorization', (value) => 'Bearer ');
//   return true;
// }
}
