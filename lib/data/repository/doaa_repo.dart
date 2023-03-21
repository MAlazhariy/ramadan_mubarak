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

  int? _lastDocTime() {
    return sharedPreferences.getInt(AppLocalKeys.LAST_DOC_TIME);
  }

  Future<ApiResponse> getData({int limit = 4, bool fromBeginning = false, int? lastDocTime}) async {
    try {
      final lastDocT = lastDocTime?? (_lastDocTime() ?? 0);
      final lastTime = fromBeginning ? 0 : lastDocT;

      final data = await FirebaseFirestore.instance
          .collection(FirebaseKeys.USERS_COLLECTION)
          .orderBy(FirebaseKeys.TIME)
          .where(FirebaseKeys.TIME, isGreaterThan: lastTime)
          .where(FirebaseKeys.USER_STATUS, isEqualTo: UserStatus.approved.name)
          .limit(limit)
          .get();

      debugPrint('get doaa data - length: "${data.docs.length}" - limit: "$limit"');

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
}
