import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/data_source/remote/dio/dio_client.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoaaRepo {
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  DoaaRepo({
    required this.sharedPreferences,
    required this.dioClient,
  });

  Future<ApiResponse> getData({
    required int limit,
    required bool fromBeginning,
    required int? lastDocTime,
  }) async {
    try {
      const defaultTimeValue = 1900391493000;
      final lastDocT = lastDocTime?? (_lastDocTime() ?? defaultTimeValue);
      final lastTime = fromBeginning ? defaultTimeValue : lastDocT;

      debugPrint('last time: $lastTime');

      final data = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .orderBy(FirebaseKeys.TIME, descending: true)
          .where(FirebaseKeys.TIME, isLessThan: lastTime)
          .where(FirebaseKeys.USER_STATUS, isEqualTo: UserStatus.approved.name)
          .limit(limit)
          .get();

      debugPrint('get doaa data - response length: "${data.docs.length}" - limit: "$limit"');

      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: data.docs
            .map((e) => {
                  'id': e.id,
                  'data': e.data(),
                })
            .toList(),
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  Future<int?> getDocsCount() async {
    try {
      final count = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .orderBy(FirebaseKeys.TIME)
          .where(FirebaseKeys.USER_STATUS, isEqualTo: UserStatus.approved.name)
          .count()
          .get();

      return count.count;
    } catch (e) {
      return null;
    }
  }

  int? _lastDocTime() {
    return sharedPreferences.getInt(AppLocalKeys.LAST_DOC_TIME);
  }

  Future<bool> updateLastDocTime(int time) async {
    return await sharedPreferences.setInt(AppLocalKeys.LAST_DOC_TIME, time);
  }
}
