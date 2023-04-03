import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  ProfileRepo(this.sharedPreferences, this.dioClient);

  Future<ApiResponse> getUserData() async {
    try {
      final userId = getUserId();
      if(userId == null){
        return ApiResponse.withError(ApiErrorHandler.handle('user id not found in local'));
      }

      final data = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .doc(userId)
          .get();

      debugPrint('user id: $userId');

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'id': data.id,
          'data': data.data(),
        },
      );
      debugPrint('getUserData response data: ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResponse> updateUser({
    required String name,
    required String doaa,
}) async {
    try {
      final user = getLocalUserDetails();
      if(user == null){
        return ApiResponse.withError(ApiErrorHandler.handle('user not found in local'));
      }

      await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .doc(user.id)
      .update({
        FirebaseKeys.NAME_UPDATE: name,
        FirebaseKeys.DOAA_UPDATE: doaa,
        FirebaseKeys.PENDING_EDIT: true,
      });

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'status': 'ok',
        },
      );

      await dioClient.postFCM(
        title: "Pending Edit..",
        body: "${user.name}->$name\n-----\nBefore:${user.doaa}\nAfter:$doaa",
      );
      debugPrint('getUserData response data: ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  String? getUserId() {
    return sharedPreferences.getString(AppLocalKeys.USER_ID);
  }

  Future<void> updateUserLocalData(UserDetails user) async {
    try {
      final userDataEncoded = json.encode(user);
      await sharedPreferences.setString(AppLocalKeys.USER_DATA, userDataEncoded);
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> updateUserDataFromJson(Map<String, dynamic> data) async {
  //   try {
  //     final userDataEncoded = json.encode(data);
  //     await sharedPreferences.setString(AppLocalKeys.USER_DATA, userDataEncoded);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  UserDetails? getLocalUserDetails() {
    final userData = sharedPreferences.getString(AppLocalKeys.USER_DATA);
    if (userData == null) {
      return null;
    }

    final userDataDecoded = json.decode(userData);

    return UserDetails.fromJson(userDataDecoded, id: userDataDecoded['id']);
  }
}
