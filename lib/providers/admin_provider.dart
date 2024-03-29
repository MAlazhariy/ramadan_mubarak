import 'package:flutter/material.dart';
import 'package:ramadan_kareem/data/model/base/response_model.dart';
import 'package:ramadan_kareem/data/model/user_details_model.dart';
import 'package:ramadan_kareem/data/repository/admin_repo.dart';
import 'package:ramadan_kareem/helpers/enums/user_role_enum.dart';
import 'package:ramadan_kareem/helpers/enums/user_status_enum.dart';
import 'package:ramadan_kareem/utils/app_string_keys.dart';

class AdminProvider extends ChangeNotifier {
  final AdminRepo adminRepo;

  AdminProvider(this.adminRepo);

  bool _isLoading = false;
  List<UserDetails> _newUsers = [];
  List<UserDetails> _updatedUsers = [];

  List<UserDetails> get newUsers => _newUsers;
  List<UserDetails> get updatedUsers => _updatedUsers;

  bool get isLoading => _isLoading;

  Future<ResponseModel> getEditsPending() async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await adminRepo.getEditsPending();
    late ResponseModel responseModel;
    _updatedUsers = [];

    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      final List<Map<String, dynamic>> data = apiResponse.response!.data;

      for (var json in data) {
        _updatedUsers.add(
          UserDetails.fromJson(
            json,
            id: json['id'],
          ),
        );
      }
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> approveUserEdits({
    required UserDetails user,
    String? name,
    String? doaa,
    bool isAdmin = false,
    required bool sendNotification,
    String? notificationTitle,
    String? notificationBody,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userName = name ?? user.nameUpdate;
    final userDoaa = doaa ?? user.doaaUpdate;
    final notifTitle = notificationTitle ?? AppStrings.defaultApproveUpdateFCMTitle;
    final notifBody = notificationBody ?? AppStrings.defaultApproveUpdateFCMBody;

    final _user = UserDetails(
      id: user.id,
      status: UserStatus.approved,
      time: user.time,
      deviceId: user.deviceId,
      name: userName,
      doaa: userDoaa,
      isAlive: user.isAlive,
      role: isAdmin ? UserRole.moderator : user.role,
      token: user.token,
    );

    final apiResponse = await adminRepo.updateUserEdits(
      user: _user,
      sendNotification: sendNotification,
      notificationTitle: notifTitle,
      notificationBody: notifBody,
    );
    late ResponseModel responseModel;
    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      // remove user from new users list
      _updatedUsers.remove(user);
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> rejectUserEdits({
    required UserDetails user,
    String? name,
    String? doaa,
    bool isAdmin = false,
    required bool sendNotification,
    String? notificationTitle,
    String? notificationBody,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userName = name ?? user.nameUpdate;
    final userDoaa = doaa ?? user.doaaUpdate;
    final notifTitle = notificationTitle ?? AppStrings.defaultRejectUpdateFCMTitle;
    final notifBody = notificationBody ?? AppStrings.defaultRejectUpdateFCMBody;

    final _user = UserDetails(
      id: user.id,
      status: UserStatus.rejected,
      time: user.time,
      deviceId: user.deviceId,
      name: userName,
      doaa: userDoaa,
      isAlive: user.isAlive,
      role: isAdmin ? UserRole.moderator : user.role,
      token: user.token,
    );

    final apiResponse = await adminRepo.updateUserEdits(
      user: _user,
      sendNotification: sendNotification,
      notificationTitle: notifTitle,
      notificationBody: notifBody,
    );
    late ResponseModel responseModel;
    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      // remove user from new users list
      _updatedUsers.remove(user);
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> getNewUsers() async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await adminRepo.getNewUsers();
    late ResponseModel responseModel;
    _newUsers = [];

    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      final List<Map<String, dynamic>> data = apiResponse.response!.data;

      for (var json in data) {
        _newUsers.add(
          UserDetails.fromJson(
            json,
            id: json['id'],
          ),
        );
      }
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> approveNewUser({
    required UserDetails user,
    String? name,
    String? doaa,
    bool isAdmin = false,
    required bool sendNotification,
    String? notificationTitle,
    String? notificationBody,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userName = name ?? user.name;
    final userDoaa = doaa ?? user.doaa;
    final notifTitle = notificationTitle ?? AppStrings.defaultApproveFCMTitle;
    final notifBody = notificationBody ?? AppStrings.defaultApproveFCMBody;

    final _user = UserDetails(
      id: user.id,
      status: UserStatus.approved,
      time: user.time,
      deviceId: user.deviceId,
      name: userName,
      doaa: userDoaa,
      isAlive: user.isAlive,
      role: isAdmin ? UserRole.moderator : user.role,
      token: user.token,
    );

    final apiResponse = await adminRepo.updateNewUser(
      user: _user,
      sendNotification: sendNotification,
      notificationTitle: notifTitle,
      notificationBody: notifBody,
    );
    late ResponseModel responseModel;
    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      // remove user from new users list
      _newUsers.remove(user);
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> rejectNewUser({
    required UserDetails user,
    String? name,
    String? doaa,
    bool isAdmin = false,
    required bool sendNotification,
    String? notificationTitle,
    String? notificationBody,
  }) async {
    _isLoading = true;
    notifyListeners();

    final userName = name ?? user.name;
    final userDoaa = doaa ?? user.doaa;
    final notifTitle = notificationTitle ?? AppStrings.defaultRejectFCMTitle;
    final notifBody = notificationBody ?? AppStrings.defaultRejectFCMBody;

    final _user = UserDetails(
      id: user.id,
      status: UserStatus.rejected,
      time: user.time,
      deviceId: user.deviceId,
      name: userName,
      doaa: userDoaa,
      isAlive: user.isAlive,
      role: isAdmin ? UserRole.moderator : user.role,
      token: user.token,
    );

    final apiResponse = await adminRepo.updateNewUser(
      user: _user,
      sendNotification: sendNotification,
      notificationTitle: notifTitle,
      notificationBody: notifBody,
    );
    late ResponseModel responseModel;
    if (!apiResponse.isSuccess) {
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    } else {
      // remove user from new users list
      _newUsers.remove(user);
      responseModel = ResponseModel.withSuccess();
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> addNewUser({
    required String name,
    required String doaa,
  }) async {
    _isLoading = true;
    notifyListeners();

    final apiResponse = await adminRepo.addNewUser(name: name, doaa: doaa);
    late ResponseModel responseModel;

    if (apiResponse.isSuccess) {
      responseModel = ResponseModel.withSuccess();
    } else {
      debugPrint('addNewUser failed: ${apiResponse.error?.message}');
      responseModel = ResponseModel.withError(apiResponse.error?.message);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void notify() {
    return notifyListeners();
  }
}
