import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/data/repository/profile_repo.dart';
import 'package:ramadan_kareem/helpers/enums/user_role_enum.dart';
import 'package:ramadan_kareem/utils/app_uri.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider(this.profileRepo);

  bool _isLoading = false;
  UserDetails? _userDetails;

  bool get isLoading => _isLoading;

  UserDetails? get userDetails => _userDetails;

  Future<ResponseModel> getUserIfNotExists() async {
    if(_userDetails != null){
      return ResponseModel.withSuccess();
    }

    return await getUserData();
  }

  Future<ResponseModel> getUserData() async {
    _isLoading = true;
    notifyListeners();

    debugPrint('getUserData..');

    final apiResponse = await profileRepo.getUserData();
    late ResponseModel responseModel;

    if (apiResponse.isSuccess) {
      responseModel = ResponseModel.withSuccess();
      _userDetails = UserDetails.fromJson(
        apiResponse.response!.data['data'],
        id: apiResponse.response!.data['id'],
      );
      debugPrint('user info: ${_userDetails!.toJson()}');
      // update user in local data
      profileRepo.updateUserLocalData(_userDetails!);
      // subscribe to topics
      if(_userDetails?.isModerator == true){
        FirebaseMessaging.instance.subscribeToTopic(AppUri.ADMIN_FCM_TOPIC);
      } else {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppUri.ADMIN_FCM_TOPIC);
      }
    } else {
      debugPrint('Login failed: ${apiResponse.error?.message}');
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateUser({
    required String name,
    required String doaa,
  }) async {
    _isLoading = true;
    notifyListeners();

    debugPrint('updateUser..');

    final apiResponse = await profileRepo.updateUser(name: name, doaa: doaa);
    late ResponseModel responseModel;

    if (apiResponse.isSuccess) {
      responseModel = ResponseModel.withSuccess();
      _userDetails?.name = name;
      _userDetails?.doaa = doaa;
      debugPrint('user new info: ${_userDetails!.toJson()}');
      profileRepo.updateUserLocalData(_userDetails!);
    } else {
      debugPrint('update data failed: ${apiResponse.error?.message}');
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}