import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/data/repository/profile_repo.dart';

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
      profileRepo.updateUserData(_userDetails!);
    } else {
      debugPrint('Login failed: ${apiResponse.error?.message}');
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}