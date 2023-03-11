import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:ramadan_kareem/data/data_source/remote/exception/api_error_handler.dart';
import 'package:ramadan_kareem/data/model/base/api_response.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  AuthRepo({
    required this.sharedPreferences,
  });

  final SharedPreferences sharedPreferences;

  // is logged in
  bool get isLoggedIn => sharedPreferences.containsKey(AppLocalKeys.USER_ID);

  // login
  Future<ApiResponse> login({
    required String name,
    required String doaa,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final deviceId = await PlatformDeviceId.getDeviceId;
      final docId = deviceId ?? '$now-$name';
      final token = await FirebaseMessaging.instance.getToken();
      final user = UserDetails(id: docId, name: name, doaa: doaa, time: now, deviceId: deviceId);

      await FirebaseFirestore.instance.collection(FirebaseKeys.USERS_COLLECTION).doc(docId).set({
        ...user.toJson(),
        'name_update': '',
        'doaa_update': '',
        'token': token??'',
      });

      await _saveUserId(docId);

      return ApiResponse.withSuccess();
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.handle(e));
    }
  }

  // token
  // Future<ApiResponse> updateFirebaseToken() async {
  //   try {
  //     late String? deviceToken;
  //     if (!Platform.isAndroid) {
  //       NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  //         alert: true,
  //         announcement: false,
  //         badge: true,
  //         carPlay: false,
  //         criticalAlert: false,
  //         provisional: false,
  //         sound: true,
  //       );
  //
  //       if (settings.authorizationStatus == AuthorizationStatus.authorized && !kIsWeb) {
  //         deviceToken = await _getDeviceToken();
  //       }
  //     } else {
  //       deviceToken = await _getDeviceToken();
  //     }
  //     FirebaseMessaging.instance.subscribeToTopic(AppStrings.TOPIC);
  //
  //     Response response = await dioClient.post(
  //       AppUri.FCM_TOKEN,
  //       data: {
  //         "_method": "put",
  //         "cm_firebase_token": deviceToken,
  //       },
  //     );
  //
  //     return ApiResponse.fromResponse(response);
  //   } catch (e) {
  //     return ApiResponse.withError(ApiErrorHandler.handle(e));
  //   }
  // }

  // Future<String> _getDeviceToken() async {
  //   late final String deviceToken;
  //
  //   if (Platform.isAndroid) {
  //     deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
  //   } else if (Platform.isIOS) {
  //     deviceToken = await FirebaseMessaging.instance.getAPNSToken() ?? '';
  //   }
  //   debugPrint('--------Device Token---------- $deviceToken');
  //
  //   return deviceToken;
  // }

  Future<void> _saveUserId(String id) async {
    // save token in shared-pref
    try {
      await sharedPreferences.setString(AppLocalKeys.USER_ID, id);
    } catch (e) {
      rethrow;
    }
  }

  String getUserId() {
    return sharedPreferences.getString(AppLocalKeys.USER_ID) ?? '';
  }

  // Future<bool> logout() async {
  //   if (!kIsWeb) {
  //     // todo: firebase method
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
