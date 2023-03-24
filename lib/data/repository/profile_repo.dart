import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final SharedPreferences sharedPreferences;

  ProfileRepo(this.sharedPreferences);

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


      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'id': data.id,
          'data': data.data(),
        },
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  String? getUserId() {
    return sharedPreferences.getString(AppLocalKeys.USER_ID);
  }

  Future<void> updateUserData(UserDetails user) async {
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
