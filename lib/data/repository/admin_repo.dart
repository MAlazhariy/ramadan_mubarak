import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRepo {
  final DioClient dioClient;

  AdminRepo(this.dioClient);

  Future<ApiResponse> getEditsPending() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .where(FirebaseKeys.NAME_UPDATE, isNotEqualTo: '')
          .get();

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: data.docs.map((e) => e.data()).toList(),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> updateUserEdits({
    required UserDetails user,
    required bool sendNotification,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(user.id).update({
        ...user.toJson(),
      });

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'status': 'ok',
        },
      );

      if(sendNotification){
        dioClient.postFCM(
          title: notificationTitle,
          body: notificationBody,
          to: user.token,
        );
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> getNewUsers() async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .orderBy(FirebaseKeys.TIME, descending: true)
          .where(FirebaseKeys.USER_STATUS, isEqualTo: UserStatus.newMember.name)
          .get();

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: data.docs.map((e) => e.data()).toList(),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> updateNewUser({
    required UserDetails user,
    required bool sendNotification,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    try {
      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(user.id).update({
        ...user.toJson(),
      });

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'status': 'ok',
        },
      );

      if(sendNotification){
        dioClient.postFCM(
          title: notificationTitle,
          body: notificationBody,
          to: user.token,
        );
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> addNewUser({
    required String name,
    required String doaa,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final deviceId = await PlatformDeviceId.getDeviceId;
      final docId = '$name-$deviceId';
      final user = UserDetails(id: docId, name: name, doaa: doaa, time: now, deviceId: deviceId);

      debugPrint('user details: ${user.toJson()}');

      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(docId).set({
        ...user.toJson(),
        'name_update': '',
        'doaa_update': '',
        'token': '',
        'added_by': '$deviceId',
      });

      return ApiResponse.withSuccess();
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }
}
