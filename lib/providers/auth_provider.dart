import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/repository/auth_repo.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({
    required this.authRepo,
  });

  bool _isLoading = false;

  bool get isLoggedIn => authRepo.isLoggedIn;

  bool get isLoading => _isLoading;

  Future<ResponseModel> login({
    required String name,
    required String doaa,
  }) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await authRepo.login(name: name, doaa: doaa);
    late ResponseModel responseModel;

    if (apiResponse.isSuccess) {
      responseModel = ResponseModel.withSuccess();
    } else {
      debugPrint('Login failed: ${apiResponse.error?.message}');
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // Future<bool> logoutAndClearData() async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   bool isSuccess = await authRepo.logout();
  //   profileProvider.clearUserData();
  //
  //   _isLoading = false;
  //   notifyListeners();
  //
  //   return isSuccess;
  // }

  String getUserId() {
    return authRepo.getUserId();
  }
}
